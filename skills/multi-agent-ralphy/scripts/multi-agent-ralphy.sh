#!/usr/bin/env bash
set -Eeuo pipefail

MAX_ITERATIONS="${MAX_ITERATIONS:-50}"
WORK_DIR="${WORK_DIR:-$PWD}"
CHROMA_STALE_S="${CHROMA_STALE_S:-900}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REFERENCE_DIR="$SKILL_DIR/references"

AUDITOR_PROMPT_FILE="$REFERENCE_DIR/AUDITOR_PROMPT.md"
WORKER_PROMPT_FILE="$REFERENCE_DIR/WORKER_PROMPT.md"

GOAL_INPUT="${*:-}"

if [[ -z "$GOAL_INPUT" ]]; then
  echo "Usage: $0 \"상위 목표\"" >&2
  exit 1
fi

if [[ ! -f "$AUDITOR_PROMPT_FILE" || ! -f "$WORKER_PROMPT_FILE" ]]; then
  echo "Error: reference prompt files are missing." >&2
  exit 1
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "Error: 'codex' CLI is required." >&2
  exit 1
fi

if ! git -C "$WORK_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: WORK_DIR must be a Git repository for automatic checkpoint commits." >&2
  exit 1
fi

GOAL_FILE="$WORK_DIR/GOAL.txt"
PRD_FILE="$WORK_DIR/PRD.md"
STATE_DIR="$WORK_DIR/.ralphy"
LOG_DIR="$STATE_DIR/logs"
PROMPT_DIR="$STATE_DIR/prompts"

mkdir -p "$LOG_DIR" "$PROMPT_DIR"

cat > "$GOAL_FILE" <<EOF
$GOAL_INPUT
EOF

cat > "$PRD_FILE" <<'EOF'
# PRD

## Top Goal
- Read `GOAL.txt` and keep every plan aligned with it.

## Task Queue
- [ ] Define the smallest verifiable milestone that directly satisfies the top-level goal.
EOF

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

snapshot_chroma_pids() {
  pgrep -f "chroma-mcp" 2>/dev/null | sort -u || true
}

terminate_pid() {
  local pid="$1"
  if ! kill -0 "$pid" 2>/dev/null; then
    return 0
  fi
  kill -TERM "$pid" 2>/dev/null || true
  local i
  for i in 1 2 3 4 5; do
    if ! kill -0 "$pid" 2>/dev/null; then
      return 0
    fi
    sleep 0.2
  done
  kill -KILL "$pid" 2>/dev/null || true
}

cleanup_chroma() {
  local before_snapshot="$1"
  local after_snapshot
  after_snapshot="$(snapshot_chroma_pids)"
  local pid

  # Reap newly leaked processes from this role execution.
  while IFS= read -r pid; do
    [[ -z "$pid" ]] && continue
    if ! grep -qx "$pid" <<<"$before_snapshot"; then
      terminate_pid "$pid"
    fi
  done <<<"$after_snapshot"

  # Reap stale processes that should no longer stay resident.
  while read -r pid etime _rest; do
    [[ -z "${pid:-}" ]] && continue
    [[ -z "${etime:-}" ]] && continue
    if [[ "$etime" =~ ^[0-9]+$ ]] && (( etime >= CHROMA_STALE_S )); then
      terminate_pid "$pid"
    fi
  done < <(ps -eo pid=,etimes=,cmd= | awk '/chroma-mcp/ {print $1, $2, $3}')
}

compose_prompt() {
  local role="$1"
  local iteration="$2"
  local role_prompt_file="$3"
  local composed_prompt="$4"

  {
    cat "$role_prompt_file"
    echo
    echo "## Runtime Context"
    echo "- Iteration: $iteration/$MAX_ITERATIONS"
    echo "- Role: $role"
    echo "- Workspace: $WORK_DIR"
    echo
    echo "## GOAL.txt"
    cat "$GOAL_FILE"
    echo
    echo "## PRD.md"
    cat "$PRD_FILE"
    echo
    echo "## Action"
    echo "Follow your role instructions exactly and apply updates in this workspace."
  } > "$composed_prompt"
}

run_role() {
  local role="$1"
  local prompt_file="$2"
  local iteration="$3"

  local composed_prompt="$PROMPT_DIR/${iteration}-${role}.md"
  local log_file="$LOG_DIR/${iteration}-${role}.log"
  local chroma_before
  chroma_before="$(snapshot_chroma_pids)"

  compose_prompt "$role" "$iteration" "$prompt_file" "$composed_prompt"

  echo "[$(timestamp)] iteration=$iteration role=$role start"
  if codex exec --skip-git-repo-check --full-auto -C "$WORK_DIR" - < "$composed_prompt" >"$log_file" 2>&1; then
    echo "[$(timestamp)] iteration=$iteration role=$role done"
    cleanup_chroma "$chroma_before"
  else
    cleanup_chroma "$chroma_before"
    echo "[$(timestamp)] iteration=$iteration role=$role failed (log: $log_file)" >&2
    return 1
  fi
}

checkpoint_git() {
  local iteration="$1"
  local role="$2"

  git -C "$WORK_DIR" add -A
  if git -C "$WORK_DIR" diff --cached --quiet; then
    return 0
  fi

  if git -C "$WORK_DIR" commit -m "ralphy: iteration ${iteration} (${role})" >/dev/null 2>&1; then
    echo "[$(timestamp)] git checkpoint committed for iteration=$iteration role=$role"
  else
    echo "[$(timestamp)] warning: git checkpoint commit failed at iteration=$iteration role=$role" >&2
  fi
}

iteration=1
no_progress_streak=0
while (( iteration <= MAX_ITERATIONS )); do
  prd_before_sha="$(sha256sum "$PRD_FILE" | awk '{print $1}')"

  if (( iteration % 2 == 1 )); then
    role="auditor"
    role_prompt="$AUDITOR_PROMPT_FILE"
  else
    role="worker"
    role_prompt="$WORKER_PROMPT_FILE"
  fi

  run_role "$role" "$role_prompt" "$iteration"
  checkpoint_git "$iteration" "$role"

  prd_after_sha="$(sha256sum "$PRD_FILE" | awk '{print $1}')"
  if [[ "$prd_before_sha" == "$prd_after_sha" ]]; then
    no_progress_streak=$((no_progress_streak + 1))
  else
    no_progress_streak=0
  fi
  if (( no_progress_streak >= 3 )); then
    echo "[$(timestamp)] no_progress_streak=$no_progress_streak; stop to prevent redundant MCP calls"
    exit 0
  fi

  if ! grep -q '^- \[ \]' "$PRD_FILE"; then
    echo "[$(timestamp)] no unchecked task left in PRD.md; stop at iteration=$iteration"
    exit 0
  fi

  iteration=$((iteration + 1))
done

echo "[$(timestamp)] reached MAX_ITERATIONS=$MAX_ITERATIONS"

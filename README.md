# codex_skills

Personal Codex skills published for GitHub-based installation.

This repository mirrors the non-system skills currently installed in `~/.codex/skills`.
The preinstalled `.system` skills are intentionally excluded.

## Layout

Each skill lives at:

```text
skills/<skill-name>/
```

## Install With Skill Installer

Example direct install:

```bash
python ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo kth-divina/codex_skills \
  --path skills/ship-learn-next
```

Example GitHub URL install:

```bash
python ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --url https://github.com/kth-divina/codex_skills/tree/main/skills/ship-learn-next
```

After installing, restart Codex to pick up new skills.

## Published Skills

- `agent-md-refactor`
- `c4-architecture`
- `codex`
- `crafting-effective-readmes`
- `database-schema-designer`
- `dependency-updater`
- `doc`
- `game-changing-features`
- `gepetto`
- `mermaid-diagrams`
- `multi-agent-ralphy`
- `naming-analyzer`
- `pdf`
- `playwright`
- `plugin-forge`
- `receiving-code-review`
- `reducing-entropy`
- `requesting-code-review`
- `requirements-clarity`
- `ship-learn-next`
- `skill-judge`
- `spreadsheet`
- `subagent-driven-development`
- `systematic-debugging`
- `verification-before-completion`
- `writing-clearly-and-concisely`

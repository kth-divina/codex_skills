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

- [`agent-md-refactor`](skills/agent-md-refactor/): Refactors bloated `AGENTS.md`, `CLAUDE.md`, and similar instruction files into smaller, linked documentation.
- [`c4-architecture`](skills/c4-architecture/): Generates software architecture documentation with C4 model Mermaid diagrams.
- [`codex`](skills/codex/): Helps with Codex CLI workflows such as `codex exec` and `codex resume`, plus Codex-driven code analysis and editing.
- [`crafting-effective-readmes`](skills/crafting-effective-readmes/): Improves README files with audience-aware templates and practical guidance.
- [`database-schema-designer`](skills/database-schema-designer/): Designs robust SQL and NoSQL schemas with normalization, indexing, migration, and constraint guidance.
- [`dependency-updater`](skills/dependency-updater/): Handles dependency upgrades across languages, including safe updates, version prompts, and issue diagnosis.
- [`doc`](skills/doc/): Supports reading, creating, and editing `.docx` documents when formatting fidelity matters.
- [`game-changing-features`](skills/game-changing-features/): Finds high-leverage product opportunities and "10x" feature ideas.
- [`gepetto`](skills/gepetto/): Builds detailed implementation plans through research, interviews, and multi-LLM review.
- [`mermaid-diagrams`](skills/mermaid-diagrams/): Provides a broad guide for creating software diagrams with Mermaid syntax.
- [`multi-agent-ralphy`](skills/multi-agent-ralphy/): Supports multi-agent autonomous goal execution and PRD orchestration.
- [`naming-analyzer`](skills/naming-analyzer/): Suggests stronger variable, function, and class names from context.
- [`pdf`](skills/pdf/): Supports reading, creating, and reviewing PDF files when rendering and layout matter.
- [`playwright`](skills/playwright/): Automates real browser tasks from the terminal for navigation, capture, extraction, and UI debugging.
- [`plugin-forge`](skills/plugin-forge/): Creates and manages Claude Code plugins, manifests, and marketplace metadata.
- [`receiving-code-review`](skills/receiving-code-review/): Evaluates code review feedback rigorously before implementing suggestions.
- [`reducing-entropy`](skills/reducing-entropy/): Minimizes total codebase size with a deletion-first approach.
- [`requesting-code-review`](skills/requesting-code-review/): Prepares work for code review and checks whether implementation meets requirements.
- [`requirements-clarity`](skills/requirements-clarity/): Clarifies ambiguous requirements with focused questions before implementation.
- [`ship-learn-next`](skills/ship-learn-next/): Turns learning materials into concrete implementation plans and next actions.
- [`skill-judge`](skills/skill-judge/): Reviews skill packages against official guidance and best practices.
- [`spreadsheet`](skills/spreadsheet/): Supports spreadsheet creation, editing, analysis, and formatting while preserving formulas and structure.
- [`subagent-driven-development`](skills/subagent-driven-development/): Helps execute implementation plans with independent tasks in the current session.
- [`systematic-debugging`](skills/systematic-debugging/): Applies a disciplined debugging process before proposing fixes.
- [`verification-before-completion`](skills/verification-before-completion/): Enforces fresh verification before claiming work is complete or correct.
- [`writing-clearly-and-concisely`](skills/writing-clearly-and-concisely/): Improves human-facing prose using concise, professional writing rules.

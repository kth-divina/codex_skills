---
name: multi-agent-ralphy
description: 다중 에이전트 기반 자율 목표 달성 및 PRD 오케스트레이션
---

# Multi-Agent Ralphy

상위 목표를 입력받아 PRD를 만들고, Auditor/Worker 루프를 자동 실행하라.

## Core Flow

1. 이 스킬이 명시적 또는 암묵적으로 호출되면 사용자에게 정확히 다음 문장을 먼저 질문하라.
   - `상위 목표가 무엇입니까?`
2. 사용자가 상위 목표를 답하면 즉시 아래 명령으로 루프를 시작하라.
   - `bash skills/multi-agent-ralphy/scripts/multi-agent-ralphy.sh "<상위 목표>"`
3. 루프 진행 중에는 `GOAL.txt`, `PRD.md`, `.ralphy/` 디렉터리를 기준으로 상태를 추적하라.
4. 루프가 중단되면 마지막 로그를 확인하고, 필요 시 동일 명령으로 재실행하라.

## References

- 감사관 역할 지침: `references/AUDITOR_PROMPT.md`
- 작업자 역할 지침: `references/WORKER_PROMPT.md`

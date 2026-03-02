---
name: arch-review
description: |
  작업 완료 후 아키텍처 적절성을 비판적으로 평가.
  "최종 검수", "arch-review", "아키텍처 리뷰", "마무리 검토" 요청 시 사용.
  별도 컨텍스트에서 실행되어 객관적 평가 제공.
context: fork
agent: architecture-reviewer
---

현재 작업 디렉토리의 최근 변경사항을 평가하세요.

**중요: `cd /path && git ...` 패턴 절대 사용 금지. git 명령어만 직접 실행.**

1. `git diff --cached --name-only`로 Staging된 변경사항 확인
2. Staging된 변경사항이 있으면 해당 파일들을 읽고 분석
3. Staging된 변경사항이 없으면 `git status`로 Untracked/Modified 파일 확인 후 사용자에게 질문
4. CLAUDE.md, docs/ 참고하여 프로젝트 컨벤션 확인
5. 비판적 평가 결과 출력

변경사항이 없으면 최근 커밋(`git show HEAD`)을 분석하세요.

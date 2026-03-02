---
name: qa-review
description: |
  코드 변경 후 테스트 커버리지 갭 분석 (백엔드 및 프론트엔드).
  "qa-review", "QA 리뷰", "테스트 커버리지 확인", "누락된 테스트 찾기" 요청 시 사용.
  별도 컨텍스트에서 실행되어 객관적 커버리지 평가 제공.
context: fork
agent: qa-reviewer
---

현재 작업 디렉토리의 최근 변경사항에서 테스트 커버리지 갭을 식별하세요.

**중요: `cd /path && git ...` 패턴 절대 사용 금지. git 명령어만 직접 실행.**

1. `git diff --cached --name-only`로 Staging된 변경사항 확인
2. Staging된 변경사항이 있으면 해당 파일과 대응하는 기존 테스트 파일을 읽고 분석
3. Staging된 변경사항이 없으면 `git status` 확인 후 사용자에게 질문
4. 이미 커버된 케이스와 누락된 케이스를 비교하여 갭 목록 출력

변경사항이 없으면 최근 커밋(`git show HEAD`)을 분석하세요.

# FuseForge 방법론 — 한국어 개념 가이드

이 문서는 FuseForge의 개념과 프로세스를 한국어로 설명한다.

> **정본은 영어다.** 실제 에이전트가 읽는 규칙은 `skills/`에 있다. 이
> 가이드는 스킬의 문장별 번역본이 아니라 안정적인 개념 설명이다. 스킬
> 구현이 바뀌더라도 제품 경계나 프로세스가 바뀔 때만 갱신한다.

## 1. FuseForge가 무엇인가

FuseForge는 Compforge와 OOPforge 위에 놓이는 **얇은 풀스택 코디네이터**다.

- Compforge: TypeScript·React 프런트엔드 규율
- OOPforge: Java Spring·Python FastAPI 백엔드 OOP/DDD 규율
- FuseForge: 공유 제품 의미, 작업공간, 위임, 결과 검증과 통합 승인

FuseForge는 전문 팩의 방법론을 복제하지 않는다. 백엔드가 프런트엔드 의미를
정하거나 프런트엔드가 백엔드 도메인을 임의로 바꾸지 못하게, 부모
코디네이터가 하나의 공유 계약과 사용자 대화를 소유한다.

## 2. 기본 워크플로

```text
Discovery → Design → Delivery Plan → Skeleton → Implement → Test
```

각 단계는 목적이 다르며 사람 승인을 받아야 다음 단계로 이동한다.

| 단계 | 목적 |
|---|---|
| Discovery | 문제, 용어, 사용자, 맥락과 열린 질문 확인 |
| Design | 공유 계약, 소유권, 상태 모델과 인터페이스 결정 |
| Delivery Plan | 구현 범위, 순서, 검증, 호환성과 위험 결정 |
| Skeleton | 동작 없이 패키지·skill·adapter 경계 생성 |
| Implement | 승인된 수직 슬라이스 하나 구현 |
| Test | packaging, harness 동작과 연결 증거 확인 |

## 3. 선택 게이트

FuseForge는 누락된 기술 선택을 조용히 추정하지 않는다.

1. 요청이 greenfield인지 기존 프로젝트인지 구분한다.
2. feature, bug fix, refactor 의도를 구분한다.
3. 프런트엔드·백엔드 중 필요한 트랙을 정한다.
4. 필요한 스택이나 greenfield topology가 비어 있으면 한 번에 묻는다.
5. 현재 하네스는 자동으로 사용하며 사용자에게 다시 고르게 하지 않는다.

선택이 끝나기 전에는 제품 파일을 만들지 않는다.

## 4. 논리 작업공간

FuseForge는 모노레포와 세 개의 work target 구성을 같은 논리 모델로 다룬다.

```text
coordination root
frontend target
backend target
shared contract
local coordinator state
```

greenfield 생성은 정확한 절대 경로를 현재 응답에서 승인받은 뒤에만 진행한다.
Git 초기화, 의존성 설치와 애플리케이션 소스 생성은 별도 승인 범위다.

## 5. 공유 계약과 로컬 상태

크로스스택 제품 의미의 정본은 다음 tracked 문서다.

```text
docs/features/<feature-slug>/contract.md
```

로컬 진행 상태는 다음에 저장한다.

```text
.craft/fuseforge/task-<feature-slug>.md
```

공유 계약에는 제품 흐름, acceptance, wire 의미와 오류 매핑을 둔다. 로컬
상태에는 절대 경로, 현재 단계, 팩 버전과 다음 결정을 둔다. 로컬 상태가 두
번째 제품 계약이 되어서는 안 된다.

## 6. 전문 팩 위임

부모는 두 전문 팩에 같은 계약 revision을 전달한다.

- 요청에는 트랙, 단계, 정확한 target, write root, 계약 경로·revision과 기대
  결과가 들어간다.
- 결과에는 상태, 실제 사용 revision, artifact, evidence, decision request,
  scope drift와 사용자용 요약이 들어간다.
- 전문 팩은 자신의 Design·Component/OOP Contract를 소유하지만 공유 계약을
  직접 수정하지 않는다.

병렬 실행은 계약이 고정되고 write root가 겹치지 않을 때만 가능한 최적화다.
순차 실행은 항상 유효한 기본 경로로 남는다.

## 7. stage barrier와 revision

필요한 결과가 없거나 failed, cancelled, decision-required, stale이면 다음
단계로 넘어가지 않는다.

두 결과가 모두 유효해도 먼저 로컬 통합 제안을 만든다. 사용자에게 보이는
행동, 데이터 의미, 오류 복구, acceptance나 범위가 바뀌면 제품 언어로 다시
묻는다. 사용자가 통합 제안을 승인한 뒤에만 부모가 공유 계약을 `rev-2`로
갱신한다.

## 8. 검증 수준

증거는 서로 구분한다.

1. 정적 packaging·routing
2. 격리 filesystem 동작
3. 인증된 live harness activation
4. 실제 frontend client → running backend 연결

현재 Claude와 Cursor live activation은 통과했다. Codex는 정적 증거만
승인됐으며 live activation은 미증명이다. 캘린더 애플리케이션이 없으므로
connected verification도 아직 없다.

## 9. 현재 범위와 다음 증명

현재 구현된 것은 선택, 전문 팩 bootstrap, greenfield workspace, 공유 계약과
Design 통합 정책이다. 완성된 풀스택 하네스라고 주장하려면 실제 캘린더 수직
슬라이스를 Compforge와 OOPforge로 구현하고, 실제 프런트엔드 API client가
실행 중인 백엔드를 호출하는 증거가 필요하다.

더 읽기:

- [지원 범위](support-scope.md)
- [경로 규약](path-convention.md)
- [검토 체크리스트](reviewer-checklist.md)
- [Test 증거](../verification/coordinator-test-2026-08-27.md)

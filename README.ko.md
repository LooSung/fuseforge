# FuseForge

FuseForge는 [Compforge](https://github.com/LooSung/compforge)와
[OOPforge](https://github.com/LooSung/oopforge)를 하나의 풀스택 기능 흐름으로
연결하는 실험적이고 얇은 풀스택 코디네이터다.

[English](./README.md) · [한국어](./README.ko.md)

## 현재 상태

Discovery, Design, Delivery Plan, Skeleton, 아홉 개 구현 슬라이스와 실험적
코디네이터 Test 체크포인트가 승인됐다. 아직 완성된 코디네이터는 아니다.

### 실제로 증명된 것

2026-08-27에 전체 흐름을 한 번 끝까지 실행해 작동하는 기능을 만들었다.

> 사용자가 일정을 만들면 저장 후 월 보기에서 그 일정을 본다.

FuseForge가 기능 요청 하나를 받아 공유 계약을 고정하고, Design과 Implement를
Compforge·OOPforge에 위임하고, 쓰지 않은 산출물을 썼다고 보고한 전문 팩 결과를
거부한 뒤, 실제 프런트엔드 API client를 실행 중인 백엔드에 대해 증명했다.
캘린더 제품은 설계상 이 저장소 밖에 있고, 이 패키지는 코디네이터 정책과 증거만
담는다.

증거: [캘린더 Slice 1](docs/verification/calendar-slice-1-2026-08-27.md)

이는 슬라이스 하나, 스택 조합 하나, 하네스 하나에 대한 결과다. 흐름이 작동함을
보여주지만 다른 스택·하네스·이후 슬라이스를 보장하지는 않는다. 무엇에 의존할 수
있는지는 [지원 범위](docs/reference/support-scope.md)를 읽는다.

승인된 제품 방향은 다음과 같다.

> 개발자는 제품 기능을 한 번 설명하고 단계마다 통합 결과 하나를 승인한다.
> 프런트엔드와 백엔드 전문 팩은 같은 제품·API 계약을 기준으로 작업한다.

Compforge는 TypeScript·React 프런트엔드 규율을 소유한다. OOPforge는 Java
Spring·Python FastAPI 백엔드 OOP/DDD 규율을 소유한다. FuseForge는
크로스스택 조정, 공유 계약 일관성, 통합 체크포인트와 연결 검증만 소유한다.

## 설치

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/LooSung/fuseforge/main/scripts/setup/quickstart.sh)"
```

`~/.fuseforge`를 클론하거나 갱신한 뒤, 발견한 하네스에 FuseForge를 설치한다.
이어서 전문 팩을 설치한다. 이 둘이 없으면 FuseForge는 위임할 수 없다.

```bash
bash ~/.fuseforge/scripts/setup/bootstrap.sh          # 먼저 계획만 출력한다
bash ~/.fuseforge/scripts/setup/bootstrap.sh --apply  # 누락된 항목만 만든다
bash ~/.fuseforge/scripts/setup/doctor.sh             # 결과를 확인한다
```

제거는 `bash ~/.fuseforge/scripts/setup/uninstall.sh`이며, 자기가 만든 symlink만
지운다. 형제 팩과 달리 FuseForge의 `bootstrap.sh`는 *전문 팩*을 설치하고,
FuseForge 자신은 `install.sh`가 설치한다. 릴리스 고정, 플래그, 수동 설치는
[설치 문서](docs/setup/install.md)를 읽는다.

## 현재 경계

- 하나의 풀스택 기능 흐름이 제품 목표다.
- 네이티브 서브에이전트는 실행 수단일 수 있지만 제품 자체는 아니다.
- tmux 기반 멀티에이전트 오케스트레이션은 범위 밖이다.
- 모노레포와 프런트엔드·백엔드 분리 구성을 모두 다룬다.
- 신규 프로젝트와 기존 프로젝트는 서로 다른 작업 맥락이다.
- 누락된 스택은 로드된 전문 팩이 실제 지원하는 선택지에서 사용자가 고른다.
- 첫 증명 대상은 수직 슬라이스로 나눈 제한된 캘린더다.
- Design, Delivery Plan, Skeleton 승인 전에는 구현을 시작하지 않는다.

## 문서

[docs/README.md](docs/README.md)에서 설정, 레퍼런스, 프로젝트, 체크포인트,
구현과 검증 문서를 찾을 수 있다.

- [한국어 개념 가이드](docs/reference/methodology.ko.md)
- [설치](docs/setup/install.md)
- [지원 범위](docs/reference/support-scope.md)
- [경로 규약](docs/reference/path-convention.md)
- [릴리스 흐름 인수 결과](docs/verification/released-flow-acceptance-2026-08-27.md)
- [캘린더 Slice 1 증명](docs/verification/calendar-slice-1-2026-08-27.md)

## 승인된 단계

- [Discovery](docs/planning/checkpoints/discovery.md) — 제품 경계, 결정, 위험, Design 질문
- [Design](docs/planning/checkpoints/design.md) — 코디네이터 계약, workspace·state 모델, 전문 팩 인터페이스
- [Delivery Plan](docs/planning/checkpoints/delivery-plan.md) — 선택 게이트, 수직 슬라이스, 검증과 위험
- [Skeleton](docs/planning/checkpoints/skeleton.md) — canonical policy와 harness adapter 구조

## 구현 슬라이스

슬라이스마다 승인된 계획서와 증거 기록이 있다. 목록은
[docs/planning/implementation/README.md](docs/planning/implementation/README.md)에 있다.

| 슬라이스 | 범위 |
|---|---|
| 1 | 요청 분류와 선택 게이트 |
| 2 | 읽기 전용 팩 doctor와 누락 항목만 만드는 명시적 bootstrap |
| 3 | 정확한 경로 승인 기반 greenfield workspace와 공유 계약 `rev-1` |
| 4 | 전문 팩 Design 위임과 부모가 소유하는 `rev-2` |
| 5 | 전문 팩 Implement 위임, 쓰기 루트, 의존성 소유권 |
| 6 | 부모가 소유하는 연결 검증과 슬라이스 완료 장벽 |
| 7 | 백엔드 트랙을 임의로 결정하지 않고 영속성을 묻는다 |
| 8 | 형제 팩과 동일한 자체 설치·제거·doctor |
| 9 | 읽기 전용 Consult: 답변, 비교, 검토, 또는 기획 문서 하나 작성 |

슬라이스는 한 번에 하나씩 승인되며, 계획서 승인 전에 구현된 슬라이스는 없다.

## 코디네이터 Test

[docs/verification/coordinator-test-2026-08-27.md](docs/verification/coordinator-test-2026-08-27.md)에 승인된 Test
체크포인트가, [docs/verification/released-flow-acceptance-2026-08-27.md](docs/verification/released-flow-acceptance-2026-08-27.md)에
공개된 `v0.1.0` 재검증 결과가 기록돼 있다.

세 하네스 모두 [스킬 디렉터리 설치](docs/setup/install.md)에서 통과한다.

- Claude Code: live activation과 Craft 전체 흐름 통과
- Codex CLI: live activation 통과
- Cursor Agent: live activation과 격리 workspace 흐름 통과
- `cursor-agent --plugin-dir`: 스킬이 로드되지 않아 지원하지 않는 설치 경로
- 실제 프런트엔드 API client → 백엔드 연결 검증: Cursor Agent에서 캘린더
  Slice 1에 대해 통과. 기록은
  [캘린더 Slice 1](docs/verification/calendar-slice-1-2026-08-27.md)

## 저장소 검사와 릴리스

`bash scripts/ci/lint-skills.sh`로 하네스 packaging, skill registry, 문서 링크를
검사한다. Pull request CI는 승인된 코디네이터 회귀 검사도 함께 실행한다.

FuseForge는 MIT License를 사용하며 릴리스는 수동으로 진행한다.
[변경 이력](CHANGELOG.md)과
[릴리스 절차](docs/reference/release-process.md)를 참고한다. readiness 검사는
commit, tag, push, GitHub Release를 자동 생성하지 않는다.

## 기여

Pull request 전에 [`AGENTS.md`](AGENTS.md)와
[`.github/CONTRIBUTING.md`](.github/CONTRIBUTING.md)를 읽는다. FuseForge는 한
번에 한 단계만 승인하므로, 승인되지 않은 단계를 구현한 변경은 병합 대신 이슈로
전환된다. 근거를 넘어서는 지원 주장은 결함으로 취급하며
[claim-gap 템플릿](.github/ISSUE_TEMPLATE/claim-gap.md)으로 신고한다.

- [행동 강령](.github/CODE_OF_CONDUCT.md)
- [보안 정책](.github/SECURITY.md)
- [리뷰어 체크리스트](docs/reference/reviewer-checklist.md)

## 아직 구현되지 않은 것

- FuseForge Consult 동작
- 캘린더 슬라이스 2~6
- 브라우저 기반 end-to-end 검증
- 프로덕션 배포
- 기존 전문 팩의 자동 업데이트·수리
- 범용 멀티에이전트 런타임

## 언어 정책

실제 에이전트가 읽는 `skills/`, script, 하네스 지시문과 정책 문서는 영어를
정본으로 사용한다. 한국어 독자는 이 README와
[`docs/reference/methodology.ko.md`](docs/reference/methodology.ko.md)를 사용한다.
스킬 전체를 1:1 번역하지 않아 번역 드리프트를 막고, 한국어 개념 가이드는
제품 개념이나 프로세스가 바뀔 때 갱신한다.

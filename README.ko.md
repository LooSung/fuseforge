# FuseForge

> **풀스택 기능은 한 번만 설명하고, 단계마다 통합된 결과 하나만 승인한다.**

FuseForge는 코딩 에이전트용 얇은 **실험적** 코디네이터다. TypeScript + React
프론트엔드와 Java Spring 또는 Python FastAPI 백엔드에 걸친 기능 하나를 받아
공유 API 계약을 고정하고, 각 쪽을 전문 팩에 맡긴다. 그리고 슬라이스 완료를
말하기 전에 실제 프론트엔드 클라이언트가 실행 중인 백엔드와 동작하는지
증명한다.

FuseForge 자신은 애플리케이션 코드를 쓰지 않는다. 각 전문 팩은 자기 규칙을
그대로 지킨다.

**Claude Code**, **Codex CLI**, **Cursor Agent CLI**에 설치되고, 세 곳 모두 실제
활성화가 통과했다. 하니스별로 실제 실행된 범위는
[지원 범위](docs/reference/support-scope.md#harness-evidence)에 있다.

[English](./README.md) · [한국어](./README.ko.md)

## Forge 패밀리

| 팩 | 대상 | 스택 |
|---|---|---|
| [Compforge](https://github.com/LooSung/compforge) | 프론트엔드 | TypeScript + React |
| [OOPforge](https://github.com/LooSung/oopforge) | 백엔드 | Java Spring · Python FastAPI |
| **FuseForge** (이 저장소) | 두 쪽에 걸친 기능 하나 | Compforge + OOPforge 조율 (실험적) |

FuseForge는 두 전문 팩이 모두 필요하다. 아래 어느 방법으로든 셋 다 준비된다.

## 설치

**Claude Code**는 플러그인 마켓플레이스로 (실험적):

```text
/plugin marketplace add LooSung/fuseforge
/plugin install compforge@forge
/plugin install oopforge@forge
/plugin install fuseforge@forge
```

다른 Forge 저장소에서 `forge`를 이미 추가했다면 첫 줄은 건너뛴다. 이 경로에서는
`doctor.sh`와 `bootstrap.sh`를 쓰지 않는다. 둘은 스크립트 설치만 확인한다.
플러그인 파일은 프로젝트 밖에 있으므로 한 번 읽기 허용이 필요하다:
[읽기 권한](docs/setup/claude-code.md#plugin-marketplace-experimental).

**Codex CLI, Cursor Agent CLI**, 또는 플러그인 없이 Claude Code를 쓸 때는 설치
스크립트로:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/LooSung/fuseforge/main/scripts/setup/quickstart.sh)"
bash ~/.fuseforge/scripts/setup/bootstrap.sh --apply   # 없으면 Compforge + OOPforge 추가
bash ~/.fuseforge/scripts/setup/doctor.sh              # 셋 다 확인
```

첫 줄은 FuseForge를 발견한 하니스에 설치한다. 하니스마다 한 가지 경로만 쓴다. `bootstrap.sh`는 `--apply` 없이
실행하면 계획만 출력한다. 릴리스 고정 설치와 제거:
[설치 가이드](docs/setup/install.md) · [bootstrap 가이드](docs/setup/bootstrap.md).

## 사용

새 제품이 놓일 폴더에서 에이전트를 시작한다. FuseForge는 새(greenfield)
워크스페이스를 만든다. 기존 저장소 두 개를 붙이는 흐름은 아직 구현되지 않았다.

```text
/fuseforge:craft 사용자가 일정을 만들면 저장 후 월 보기에서 그 일정을 본다
/fuseforge:consult 에러 코드를 공유 계약에 넣어야 할까?
```

| 하니스 | 호출 방법 |
|---|---|
| Claude Code | `/fuseforge:craft <요청>` · `/fuseforge:consult <질문>` |
| Codex CLI · Cursor Agent CLI | `Use FuseForge craft: <요청>` · `Use FuseForge consult: <질문>` |

| 명령 | 언제 쓰나 | 절대 하지 않는 것 |
|---|---|---|
| `craft` | 풀스택 기능 하나를 선택 게이트부터 연결 검증까지 | 지정하지 않은 스택을 몰래 고르기, 앱 코드 직접 작성 |
| `consult` | 질문, 비교, 리뷰, 계획 문서 1개 | 제품 동작 구현 |

## 동작 방식

1. **선택 게이트.** 요청이 비워 둔 것을 묻는다: 프론트엔드·백엔드 스택,
   모노레포인지 저장소 분리인지, 데이터가 브라우저를 넘어 남아야 하는지.
2. **공유 계약.** 정확한 작업 경로를 확인받은 뒤 제품 의미 계약 `rev-1`을 쓴다.
3. **전문 팩의 Design, 그다음 Implement.** Compforge와 OOPforge가 각자
   설계하고, 사용자는 통합된 결과(`rev-2`) 하나를 승인한다. 이어서 각 전문 팩이
   자기 쓰기 범위 안에서 구현하고, FuseForge는 하지 않은 작업을 했다고 주장하는
   결과를 거절한다.
4. **연결 검증.** 실제 프론트엔드 클라이언트가 실행 중인 백엔드와 통과하고
   그 결과가 기록되어야만 슬라이스가 완료된다.

## 현재 상태: 증명된 것

2026-08-27에 전체 흐름을 한 번 끝까지 실행해 작동하는 기능을 만들었다:
*사용자가 일정을 만들면 저장 후 월 보기에서 그 일정을 본다.* 근거:
[calendar Slice 1](docs/verification/calendar-slice-1-2026-08-27.md).

이것은 **슬라이스 하나, 스택 조합 하나, 하니스 하나**다. 흐름이 작동한다는
증거이지, 다른 스택·하니스·이후 슬라이스를 약속하지 않는다. 무엇이든 의존하기
전에 [지원 범위](docs/reference/support-scope.md)를 읽는다.

현재 범위 밖: tmux 데몬, 자율 머지 파이프라인, 범용 멀티 에이전트 런타임.

## 더 보기

- 설정: [설치](docs/setup/install.md) · [Bootstrap](docs/setup/bootstrap.md) ·
  [Claude Code](docs/setup/claude-code.md) · [Codex](docs/setup/codex.md) ·
  [Cursor](docs/setup/cursor.md)
- [지원 범위](docs/reference/support-scope.md) ·
  [검증 기록](docs/verification/README.md) ·
  [한국어 방법론 가이드](docs/reference/methodology.ko.md) · [전체 문서](docs/README.md)
- 만들어진 과정: [승인된 체크포인트](docs/planning/checkpoints/README.md) ·
  [구현 슬라이스](docs/planning/implementation/README.md)
- [변경 이력](CHANGELOG.md) · [릴리스 절차](docs/reference/release-process.md) ·
  [기여 가이드](.github/CONTRIBUTING.md) · [메인테이너용 에이전트 노트](AGENTS.md)

과장된 지원 주장은 결함으로 취급한다.
[claim-gap 템플릿](.github/ISSUE_TEMPLATE/claim-gap.md)으로 제보한다.

## 라이선스

MIT

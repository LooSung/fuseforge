# FuseForge — Implementation Slice 1

- Status: Approved for next coordinator slice
- Date: 2026-08-26
- Approved: 2026-08-26
- Input: Approved `docs/planning/checkpoints/skeleton.md`
- Version: `0.1.0-alpha.1`

## 1. User outcome

When a developer starts coordinated work without all required stack or
greenfield topology choices, FuseForge:

1. classifies the observable request context, intent, and required tracks;
2. uses the current Claude, Codex, or Cursor harness without asking again;
3. offers only choices supported by observable specialist packs;
4. asks for all missing stack and topology decisions in one checkpoint;
5. stops before creating product files.

## 2. Implemented scope

- canonical activation probe and Craft routing in `skills/SKILL.md`;
- read-only selection-gate policy in `skills/workflow/craft.md`;
- classification boundary in `skills/coordination/logical-workspace.md`;
- Claude Craft command routing;
- Codex canonical skill manifest routing;
- Cursor canonical skill wrapper routing;
- one shared experimental version across stability and harness manifests;
- dependency-free static validation.

## 3. Explicitly deferred

- Consult behavior;
- bootstrap and specialist installation;
- product path creation;
- shared-contract and `.craft/fuseforge/` persistence;
- specialist delegation and stage barriers;
- connected verification;
- calendar frontend and backend source;
- commits, remotes, deployment, and CI workflows.

## 4. Evidence

Static command:

```text
python3 scripts/ci/check-selection-gate.py
FuseForge selection-gate checks passed
```

Live Cursor activation probe:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

Live Cursor greenfield calendar prompt:

```text
선택이 보류되어 작업을 중단했습니다. 제품 파일은 생성하지 않았습니다.
프런트엔드·백엔드 스택과 프로젝트 배치를 선택하면 계속할 수 있습니다.
```

The live prompt stopped at the selection boundary. Claude Code and Codex
adapter structure and shared-version consistency are statically verified but
their activation probes have not been executed live in this slice.

## 5. Implement checkpoint — approved 2026-08-26

The maintainer approved:

- automatic use of the current harness;
- one combined missing stack/topology checkpoint;
- the read-only stop boundary;
- experimental three-adapter packaging;
- the distinction between one live Cursor probe and static Claude/Codex
  verification.

This approval authorizes planning one next coordinator slice. It does not
authorize calendar source or multiple implementation slices.

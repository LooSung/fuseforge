# Track classification — before and after

- Date: 2026-08-27
- Status: Recorded; awaiting maintainer approval
- Subject: published `v0.2.0` at `d0ad74d`, then the slice 7 policy change
- Harness: Claude Code 2.1.212, skill-directory install
- Packs: Compforge 1.3.1, OOPforge 1.4.2

## What was measured

One request, repeated from separate empty directories, outside this repository:

```text
/fuseforge:craft 월별 보기가 있는 캘린더 앱을 만들어줘.
```

The request deliberately does not say whether schedules must survive closing the
browser. That silence is the ambiguity under test.

A single run proves nothing here, because the failure is a distribution rather
than a crash. Each measurement is eight runs.

## Result

| Outcome | `v0.2.0` | After slice 7 |
|---|---|---|
| Backend track left unresolved and asked as a gate question | 3 of 8 | **8 of 8** |
| Decided frontend-only; backend track dropped without asking | 5 of 8 | 0 of 8 |

The three `v0.2.0` runs that asked were the correct ones. The five that decided
took a product decision from the user and silently removed the backend
specialist, which is the coordinator's reason for existing.

## The question the gate now asks

From run 4 of the post-fix measurement, unedited:

```text
**1. Should calendar data persist after the browser is closed?**
- A) Browser-only (localStorage) — simplest, no backend needed, but data is lost
  if browser storage is cleared or app is used on another device.
- B) Saved on a server — data persists across devices/sessions, but requires a
  backend stack (Java Spring or Python FastAPI) and more setup.

**2. (If B is chosen) Which backend stack?**
```

The backend stack question is conditional on the answer, so a browser-only user
is not asked to choose a server language.

## Verified for all eight post-fix runs

- the frontend track is settled and the backend track is explicitly unresolved;
- the persistence choice appears inside the Selection Gate, not only as a note;
- no file was created in any run directory;
- seven of eight stated in words that no product files were created. Run 7
  omitted that sentence while still writing nothing, so the statement is not yet
  reliable even though the behavior was.

## Root cause that was corrected

Three passages in `skills/workflow/craft.md` pushed the wrong way together:

1. section 2 listed required tracks under "Classify what can be inferred";
2. section 4 named stacks and topology as user decisions but never a track;
3. section 4's "do not ask for a backend choice for frontend-only work" rewarded
   deciding frontend-only, because the decision made asking forbidden.

Section 2.1 now states that a track is settled only when the request states it or
an existing project shows it, and the "do not ask" entry applies only to work
that is *stated or observed* to be frontend-only.

## Two defects found while reproducing

### `v0.2.0` shipped a self-contradicting skill

`skills/SKILL.md` required a parent-owned connected check for slice completion
and then called `coordination/connected-verification.md` a Skeleton interface.
Slice 6 promoted that policy and updated `skills/stability.json` but left the
sentence.

All eight checks passed because `check-harness-packaging.py` validated each
policy file's own status line and never validated SKILL.md's claims about other
files. It now compares that claim against the registry, and the check rejects the
exact text that shipped.

### An unreadable workflow file produced an invented gate

Twelve non-interactive runs without an explicit directory grant could not read
`workflow/craft.md`. Eleven stopped and said so, which is correct. One produced
`## Assumptions` and `## Selection Gate` headings anyway, with a frontend-only
classification and no stack or topology choices.

`SKILL.md` step 1 said to read the file and stated no rule for failing to read
it. It now requires stopping, and forbids emitting any section of the response
contract without having read the policy that defines it.

The permission behavior itself is not a policy defect. Non-interactive Claude
Code sessions restrict reads outside the working directory, and the documented
interactive install is unaffected. The measurements above therefore granted the
skill directories explicitly, so that the classification question was measured
rather than the permission question.

## Method and integrity

- runs happened in `~/ff-cls-runs/` and `~/ff-cls-after/`, outside this
  repository, each in its own empty directory;
- the skill was linked into `~/.claude/skills/fuseforge` for the measurement and
  the link was removed afterward. No such link existed beforehand;
- `~/.claude/skills/` and `~/.claude/commands/` were returned to their prior
  contents, holding only Compforge and OOPforge;
- no run wrote a file, and no product workspace was created.

## Static evidence

```text
FuseForge repository lint: OK JSON, PASS static harness packaging, OK doc links
FuseForge selection-gate checks passed
FuseForge workspace-contract checks passed
FuseForge delegation-barrier checks passed
FuseForge implement-delegation checks passed
FuseForge connected-verification checks passed
```

Eleven injected violations were each rejected, then reverted:

| Injected violation | Rejected by |
|---|---|
| Section 2.1 heading removed | selection gate |
| "Silence is not a decision" weakened | selection gate |
| The self-decided frontend-only loophole restored | selection gate |
| Track dropped from the user-decision sentence | selection gate |
| Gate template narrowed back to stack and topology | selection gate |
| Read-failure stop rule removed | selection gate |
| Invented-gate prohibition removed | selection gate |
| SKILL.md track rule removed | selection gate |
| The exact `v0.2.0` contradiction reintroduced | harness packaging |
| Skeleton policy omitted from the SKILL.md claim | harness packaging |
| Cursor wrapper rule removed | selection gate |

A first attempt at these tests restored files with `git checkout -- skills/`
while the slice was uncommitted, which reverted the change under test instead of
the injected violation. Five results were invalid and were discarded. The rerun
restores from a copy outside Git and asserts that the baseline passes before
trusting any rejection.

## Assertions no longer depend on line wrapping

Several checks matched raw text spanning a line break, so rewrapping an unrelated
paragraph failed them. That invites weakening the marker instead of reading it.
`check-selection-gate.py` and `check-workspace-contract.py` now collapse
whitespace before matching, and `check-harness-packaging.py` reads the skeleton
claim as a paragraph.

## Limitations

- Eight runs measure a distribution. A rare wrong branch may still exist; this
  records 8 of 8 observed, not a guarantee.
- One harness, one request, one language mix. Other phrasings that imply
  persistence without stating it were not measured.
- The `v0.2.0` measurement and the post-fix measurement ran on the same day and
  harness version, so the comparison holds the environment constant but does not
  establish behavior over time.
- Run 7 shows the "no product files" statement is not yet reliably emitted, even
  though every run stayed read-only.

## Not claimed

Context, intent, and topology classification were not measured. Existing-project
inference was not measured. No calendar product source exists in this pack.

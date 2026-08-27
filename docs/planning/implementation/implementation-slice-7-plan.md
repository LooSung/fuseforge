# FuseForge — Implementation Slice 7 Plan

- Status: Approved 2026-08-27
- Input: reproduction evidence from the published `v0.2.0`

## Product-language outcome

When a user asks for something that may or may not need saved data, FuseForge
asks whether the data must outlive the browser instead of quietly deciding.

Today it decides on its own most of the time, and it decides "no backend". A
user who wanted saved schedules gets a browser-only app, and the backend
specialist never participates.

## Why this is a coordinator defect, not a model quirk

Persistence is a product decision in the user's language. The approved product
boundary already says the user approves product behavior and the parent owns
shared decisions. Inferring "no backend" from silence takes a product decision
away from the user and removes the reason the coordinator exists.

## Observed behavior at `v0.2.0`

The same request, run eight times from separate empty directories on Claude
Code, split two ways:

| Behavior | Runs |
|---|---|
| Decided frontend-only; backend track dropped without asking | 5 |
| Asked whether a backend is needed | 3 |

The three runs that asked were correct. No run invented a stack or wrote a file,
so the defect is a silently narrowed scope rather than an unsafe write.

## Root cause in the text

Three passages push toward the wrong branch together:

1. section 2 lists required tracks under "Classify what can be inferred", so
   track selection reads as an inference;
2. section 4 names stacks and topology as user decisions and never names an
   ambiguous track;
3. section 4's "Do not ask for a backend choice for frontend-only work" rewards
   deciding frontend-only, because the decision itself makes asking forbidden.

## Two defects found while reproducing

### The skill contradicts itself and the registry

`skills/SKILL.md` requires a parent-owned connected check for slice completion
and then calls `coordination/connected-verification.md` a Skeleton interface.
Slice 6 moved that policy to implemented and updated `skills/stability.json` but
left the closing sentence. Shipped in `v0.2.0`.

Every check passed because `check-harness-packaging.py` validates each policy
file's own status line and never validates SKILL.md's claims about other files.

### An unreadable workflow file produces an invented gate

`SKILL.md` step 1 says to read `workflow/craft.md` and states no rule for
failing to read it. In one observed run the read was denied and the response
still produced `## Assumptions` and `## Selection Gate` headings, with a
frontend-only classification and no stack or topology choices. Output that looks
like the gate without the policy behind it is worse than a refusal, because a
reader cannot tell the difference.

## Scope

In scope:

- make an ambiguous track a selection-gate question with a stated trigger;
- correct the SKILL.md skeleton claim;
- require stopping when a required policy file cannot be read;
- compress `craft.md` section 3 to fit the change under the 200-line cap;
- extend static checks to cover all three, including SKILL.md claim consistency;
- re-measure the live behavior and record both measurements.

Out of scope:

- classification of context, intent, or topology;
- existing-project inference;
- the `--add-dir` requirement for non-interactive Claude Code sessions, which is
  a harness permission behavior and not a policy defect;
- any calendar product source.

## Write scope

```text
skills/SKILL.md
skills/workflow/craft.md
.cursor-plugin/skills/fuseforge/SKILL.md
scripts/ci/check-harness-packaging.py
scripts/ci/check-selection-gate.py
docs/planning/implementation/implementation-slice-7*.md
docs/planning/implementation/README.md
docs/verification/track-classification-2026-08-27.md
docs/reference/support-scope.md
CHANGELOG.md
```

No product workspace is touched.

## The rule to add

A track is settled only when the request states it, or an existing project shows
it. Otherwise the backend track is a gate question.

The trigger is stated in product language rather than as a keyword list: if the
request does not say whether the data must still be there after the browser is
closed, ask. The question offers browser-only storage and a saved-on-a-server
option, each with one consequence, in the same single checkpoint as the stack
and topology questions.

The "do not ask" list keeps its intent but loses the loophole: a backend choice
is skipped only for work that is *stated or observed* to be frontend-only, not
for work the agent has just decided is frontend-only.

## Verification

Static, on this pack:

- the full existing check suite continues to pass;
- new assertions fail when any of the three rules is removed;
- injected violations are reverted and the suite passes again.

Behavioral, on a real harness:

- the same request runs at least eight times from separate empty directories;
- the recorded outcome is the distribution, not a single run;
- a fix that does not change the observed distribution is reported as not
  working rather than as a policy improvement.

The reproduction environment is a temporary skill link removed afterward, and the
runs happen outside this repository.

## Risks

- Eight runs measure a distribution, not a guarantee; a rare bad branch may
  survive and must be reported as possible rather than as fixed.
- Asking one more question makes the common frontend-only case slightly slower.
  Accepted: silently dropping a track is the worse failure.
- `craft.md` compression must not change approved meaning. Section 3's rules are
  preserved and only the wording is shortened.

## Checkpoint

The slice is complete when static checks pass, the re-measured distribution is
recorded, and the maintainer approves the release.

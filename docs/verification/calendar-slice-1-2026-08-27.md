# Calendar Slice 1 — coordinator proof

- Date: 2026-08-27
- Status: Recorded; awaiting maintainer approval
- Harness: Cursor Agent
- Packs: Compforge 1.3.1, OOPforge 1.4.2
- Coordinator slices exercised: 1 through 6

## What this establishes

FuseForge coordinated a real full-stack feature across two specialist packs, and
the resulting frontend client was proven against a running backend.

> A user creates a schedule and sees it on the month view after it is saved.

This is the first execution of the approved coordinator flow end to end. Until
now, slices 5 and 6 were policy verified only.

## Product workspace

The calendar product lives outside this repository, as the approved Delivery Plan
requires. This pack contains no calendar source.

```text
~/fuseforge-calendar-proof/          coordination root, parent-owned
  docs/features/calendar/
    contract.md                      shared contract, rev-2
    connected-verification.md        connected evidence, parent-owned
  frontend/                          Compforge work target
  backend/                           OOPforge work target
  .craft/fuseforge/                  local continuity, git-ignored
```

Stacks: TypeScript + React with Vite, and Python FastAPI. Topology: monorepo.
Persistence: one application-local SQLite file through the Python standard
library. No database server, container, or external service was introduced.

Git was not initialized, so staleness detection was contract-revision only and
code-drift assurance was reduced. This was disclosed at every checkpoint.

## Flow as executed

| Step | Outcome |
|---|---|
| Selection gate | Stacks and monorepo topology explicit; closed without writing |
| Workspace creation | Created only after exact-path confirmation |
| Contract `rev-1` | Product semantics only; wire semantics left unresolved |
| Design delegation | Both tracks against `rev-1`, disjoint document roots |
| Design validation | Backend result **rejected**, then retried and accepted |
| Wire integration | 18 decision requests reduced to 16; 14 parent-resolved, 2 escalated |
| Contract `rev-2` | Applied by the parent only after user approval |
| Implement delegation | Both tracks against `rev-2`, disjoint source roots |
| Implement validation | Both accepted after independent filesystem and test checks |
| Connected verification | Parent-run; passed |

## The barrier actually rejected work

This is the part worth reporting honestly, because a coordinator that never
blocks anything is not doing its job.

The backend Design claimed an OOP Contract in its result envelope, but the
document contained none. The parent found this by grepping the artifact rather
than trusting the envelope, then confirmed against the OOPforge skill itself
that the artifact is genuinely defined there, at `workflow/craft.md` lines 99 to
113. So the expectation was correct and the omission was a real defect.

The backend track was rejected and retried against unchanged `rev-1`. The
frontend result was preserved untouched during that retry, as the delegation
policy requires. The retry supplied all six OOP Contract fields with skill
citations.

Both Design results returned `decision_required`, so the barrier stayed closed
until the user approved the integrated wire checkpoint.

## Decisions escalated to the user

The parent resolved technical naming that preserved approved meaning: paths,
field casing, status codes, the error-code vocabulary, empty-month
representation, absent-value encoding, create response body, idempotency
substitution, and local ports.

Two items were escalated because they changed product surface rather than
naming:

1. **Input length limits.** `rev-1` set none, and the limits change what a user
   may type. Approved as title 200, location 200, notes 2000 characters.
2. **Month navigation.** The frontend flagged it as its own scope judgement.
   Acceptance example 2 uses a fixed date of 2026-09-10, which cannot be checked
   from a fixed current-month view. Approved as in scope for Slice 1.

## Connected verification result

Full record: `~/fuseforge-calendar-proof/docs/features/calendar/connected-verification.md`.

The check imports the same `calendarApi` module the application's hooks use, with
no mock or re-implementation of either side, and uses the real `fetch` transport.

```bash
# backend, storage redirected to a throwaway file
uv run uvicorn app.main:create_app --factory --host 127.0.0.1 --port 8000

# parent-run check
CONNECTED_BASE_URL=http://127.0.0.1:8000 npm run test:connected
```

Readiness was polled until `GET /api/schedules?month=2026-09` returned `200`; it
became ready on the second poll. Teardown ran after every run.

Result: 1 file, 4 tests, all passed.

- creates a schedule and lists it back for that month;
- carries the application-timezone offset on a returned moment;
- maps a rejected schedule to Invalid with a reason the user can read;
- rejects a schedule with no title rather than storing one.

Acceptance example 8 was additionally proven at the transport level: with two
schedules stored, the backend was stopped and restarted on the same storage file
and the month listing returned an identical payload.

### The check cannot pass vacuously

| Condition | Observed |
|---|---|
| No backend running | Exit code 1; all four cases failed, naming the unreachable base URL |
| `CONNECTED_BASE_URL` unset | Suite failed before any case ran |

## Specialist evidence, independently re-run

The parent re-ran both suites to validate the reported claims rather than
trusting the envelopes. This is claim validation, not authorship of specialist
evidence.

| Track | Reported | Parent re-run |
|---|---|---|
| Backend | 75 pytest passed; mypy strict clean over 29 files | Identical |
| Frontend | 103 vitest tests over 14 files; typecheck clean | Identical |

## Boundary checks

Verified against the filesystem, not against the result envelopes:

- the shared contract was never edited by a specialist and stayed parent-owned;
- neither track wrote outside its assigned work target;
- the coordination root held only parent-owned files;
- no Git repository was created anywhere in the workspace;
- no Dockerfile, compose file, container, or external service appeared;
- no update, delete, or other excluded endpoint was implemented;
- no calendar source entered this pack.

## Dependencies installed by specialists

Each inside its own work target only. The parent ran no package manager.

- frontend: React 19, TanStack Query, Vite, TypeScript, Vitest, Testing Library,
  ESLint and their type packages;
- backend: FastAPI, Pydantic, Uvicorn, plus pytest, httpx, and mypy for
  development.

Persistence uses the Python standard library, so no database package was added.

## Known limitations

- A single SQLite file assumes a single process; concurrent writers are outside
  Slice 1.
- There is no schema migration path; a column change means discarding the local
  file.
- KST is treated as a fixed offset. A timezone with daylight saving would break
  month-window calculation.
- No browser was driven, so rendering is covered by frontend tests rather than by
  the connected check.
- Two non-blocking backend decision requests remain, both with working interim
  behavior: a code for schema violations that `rev-2`'s four-code vocabulary does
  not cover, and whether a rejection reports every violation or only the first.
- `skills/workflow/craft.md` is at 198 of its 200-line limit, so the next slice
  needing Craft routing must compress it first.

## Not claimed

Calendar slices 2 through 6, browser end-to-end coverage, deployment, production
readiness, multi-user behavior, and FuseForge Consult remain unimplemented.

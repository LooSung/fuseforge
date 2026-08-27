# Connected Verification Interface

Status: **Experimental — parent-owned connected check**.

For each implemented product slice, FuseForge owns evidence that:

> The real frontend API client called a running backend and observed the
> approved request, response, and error meaning.

The evidence references the shared-contract revision and complements
specialist-owned frontend and backend tests.

OpenAPI-only validation is insufficient. Browser E2E, deployment, and
production readiness remain separate opt-in scopes.

## Ownership

The frontend specialist writes the connected check inside its own work target,
reading the backend base URL from the environment. The parent starts the backend,
runs that one named check, and writes the evidence record.

The parent runs no specialist suite to manufacture specialist evidence. This
single commissioned check is the one exception, and it is parent-run by design.

The parent never writes the check, product source, or a test that replaces a
specialist's own suite.

## What the check proves

The check must use the actual frontend transport client and the actual backend
HTTP adapter, never a re-implementation or a mock of either side. It proves:

- at least one accepted product flow end to end;
- the error meaning the frontend state depends on;
- application-timezone offset behavior whenever the slice involves time;
- the shared-contract revision it ran against.

A browser is not required. Importing the real client module and pointing it at a
running backend is the actual client boundary.

## Backend lifecycle

The parent:

1. confirms every required track is complete and current on the approved
   revision;
2. starts the backend from the backend target using the command the backend
   specialist reported;
3. waits for readiness by polling the backend's own endpoint;
4. runs the one named connected check;
5. stops the backend, including on failure;
6. records the outcome.

Poll for readiness rather than sleeping a fixed interval. A readiness timeout is
a failed check, never a pass. Teardown always runs. Persistence stays
application-local, so introduce no database server, container, or external
service. Report a port conflict instead of editing product source.

## Evidence record

The parent writes the record in the product workspace, beside the contract it
cites:

```text
<coordination-root>/docs/features/<feature-slug>/connected-verification.md
```

Product evidence never lands in a pack repository. The record states:

- the date and the contract revision proven;
- the frontend and backend commands actually run;
- the accepted flow proven, in product language;
- the error case proven and the frontend state it maps to;
- the timezone behavior observed;
- what was not proven, including browser behavior and deployment;
- the specialist test results this complements.

Never record an outcome that was not observed. A blocked or failed check is
recorded as blocked or failed.

## Completion rule

A product slice is complete only when every required track is complete on the
approved revision and the connected check passed and was recorded. Until then,
report the feature as not proven end to end.

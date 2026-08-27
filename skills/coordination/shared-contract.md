# Shared Feature Contract Interface

Status: **Experimental — product-semantics `rev-1` creation**.

The tracked product contract will be owned by the FuseForge parent at:

```text
docs/features/<feature-slug>/contract.md
```

Its approved interface contains:

- feature identity and `rev-N`;
- approved scope and acceptance examples;
- API operations, schemas, and errors;
- cross-stack time and data rules;
- backend outcome to frontend state mapping;
- evidence ownership;
- unresolved product decisions.

Compforge and OOPforge artifacts reference this revision but remain separate.
OpenAPI is a wire projection, not the complete product contract.

## Initial calendar contract

After exact workspace-path confirmation, the parent may create:

```text
docs/features/calendar/contract.md
```

Use these top-level sections:

```markdown
# Calendar Shared Feature Contract

- Revision: rev-1
- Status: Product semantics approved; wire semantics unresolved

## Approved scope
## Product concepts
## Acceptance examples
## Time and timezone
## Recurrence
## Product states and errors
## Exclusions
## Evidence ownership
## Unresolved wire decisions
```

Record the approved meanings of schedules, internal calendars and colors,
year/month/week/day views, weekly and yearly recurrence, whole-series
edit/delete, foreground reminders, UTC persistence, application-timezone
offset display, and the initial KST default.

Acceptance examples must remain in product language. Include create/read/update/
delete, view switching, calendar distinction, whole-series recurrence changes,
foreground reminders, invalid time ranges, not found, and retryable connection
outcomes.

The exclusions remain external synchronization, background/email/push
delivery, per-user timezones, per-occurrence recurrence exceptions, and
production operations.

Under unresolved wire decisions, explicitly defer HTTP operations, endpoint
paths, request and response schemas, transport status mapping, error codes,
authentication, idempotency, concurrency, and specialist design. Do not guess
them.

Absolute paths, pack versions, harness identity, and session progress are
forbidden in the tracked contract.

Only the parent creates `rev-1`.

## Approved wire revision

Specialist proposals remain local and non-authoritative while the contract is
`rev-1`. After the user approves one integrated wire checkpoint, only the
parent may:

1. change the revision to `rev-2`;
2. add approved HTTP operations and endpoint meanings;
3. add request, response, error, authentication, time, idempotency, and
   concurrency semantics;
4. map backend outcomes to frontend states;
5. remove only resolved wire decisions from the unresolved section.

Preserve approved product semantics and exclusions. Specialist Design
documents remain evidence referencing `rev-1`; all later delegation must use
`rev-2`.

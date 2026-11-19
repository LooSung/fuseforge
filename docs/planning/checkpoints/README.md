# Workflow checkpoints

- [Discovery](discovery.md)
- [Design](design.md)
- [Delivery Plan](delivery-plan.md)
- [Skeleton](skeleton.md)

These files are the authoritative approved checkpoint artifacts.

## Completion criteria

Each stage is complete only when the maintainer can decide the questions below,
and moving to the next stage needs explicit human approval.

**Discovery** (approved 2026-08-26):

- whether the problem and target user are real;
- whether a separate coordinator is the correct product boundary;
- what must be shared between specialist tracks;
- what belongs explicitly outside the first Design;
- which open questions must be answered before Design.

**Design** (approved 2026-08-26):

- the coordinator contract and one source of truth for shared semantics;
- ownership and escalation rules across the parent and specialist tracks;
- the logical-workspace, contract-revision, track-result, and stage-barrier
  state models;
- the smallest sibling-aligned harness structure and interfaces;
- the default user flow, including mandatory stack ambiguity checks;
- the calendar proof semantics and boundaries needed for Delivery Planning.

**Delivery Plan** (approved 2026-08-26):

- the first proof's frontend stack, backend stack, topology, and local database;
- the ordered vertical slices and acceptance examples;
- the Skeleton scope and non-overlapping write roots;
- static, specialist, and connected verification for each slice;
- compatibility assumptions, failure handling, and delivery risks.

**Skeleton** (approved 2026-08-26):

- whether the file tree matches the approved sibling-aligned boundary;
- whether canonical policy and harness adapters are separated;
- whether every created file expresses an approved interface;
- whether any implementation behavior, dependency, or empty placeholder scope
  was introduced early;
- whether the first implementation slice can begin without restructuring the
  package.

**Implement** — each slice is complete only when:

- its product-language outcome and write scope were approved in advance;
- it preserves the shared contract and specialist ownership boundaries;
- focused static and behavior checks pass;
- no later slice or unsupported harness behavior was added;
- the maintainer approves moving to the next slice or Test.

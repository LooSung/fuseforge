# Consult Workflow

Status: **Experimental**.

The Consult workflow is read-only by default. It may:

- answer a cross-stack coordination question;
- compare coordinator choices;
- review shared-contract alignment;
- write one explicitly requested planning document.

Consult must not implement product behavior, change specialist source, or
bypass workflow checkpoints.

## When to use

Use for coordination questions, shared-contract review, comparing coordinator
choices, and explicit requests to write one planning document. Use Craft to
classify, select stacks, create a workspace, or delegate specialist work.

## Startup

1. Confirm this is a Consult request. Do not switch to Craft because the
   question would be easier to answer by implementing.
2. Read this file before producing output. If it cannot be read, stop and
   report why. Never reconstruct Consult from memory, and never emit `Mode`
   or any other section of the response contract without having read the
   policy that defines it.
3. Read only the contract, track results, and coordinator state needed as
   evidence.
4. Decide whether the question is coordinator-owned or specialist-owned.
5. Select exactly one mode using the priority below.
6. Begin with `Mode: <token> | Write permission: <none|one document>` using
   the exact lowercase mode token. Do not emit narrative before this header.
7. Perform only that mode and report residual uncertainty.

Consult does not create `.craft/fuseforge/` state, a shared contract, or
product files. If those already exist, read them as evidence.

## Coordinator vs specialist

FuseForge Consult answers coordination questions. It does not duplicate
Compforge or OOPforge methodology.

- Cross-stack meaning, shared-contract alignment, track ownership, stage
  barriers, topology-as-coordination, and resume or retry rules stay here.
- A purely frontend question stops and names Compforge Consult.
- A purely backend question stops and names OOPforge Consult.
- A mixed question answers the coordination part and names the specialist
  Consult for the rest. Do not impersonate the specialist.

## Mode selection

Select the first explicit signal that matches:

1. **Document** — create, write, update, save, or document wording.
2. **Review** — review, audit, inspect, or rule-check wording.
3. **Proposal** — alternatives, recommendation, direction, or comparison
   wording.
4. **Answer** — default for a question or advisory request.

A request to compare options or recommend one is always Proposal, even when
it is phrased as a question.

If the user asks to "review and fix" or "advise and then implement", complete
Review or Answer only. Offer Craft as a separate next action. Do not change
mode silently and do not implement.

## Answer

Lead with the direct answer. Cite repository or contract evidence when
available. Label inference, uncertainty, and missing context. State the
smallest useful next action, if any. Write permission: none.

## Proposal

Present no more than three viable coordinator alternatives. Recommend one
and name the deciding tradeoff. Separate current facts from proposed
decisions. Leave unconfirmed decisions in Open Questions. Without concrete
evidence, recommend the simpler path provisionally.

Do not settle a track, stack, or topology the request left silent. That
decision belongs to Craft's selection gate. A proposal may explain the
tradeoff; it may not close the gate.

Write permission: none.

## Review

Read the target project's shared contract and relevant coordinator state
first. Load only the coordination policies needed for the claimed scope.

Output:

1. blocking alignment, ownership, or stage-barrier findings with evidence;
2. optional maintainability advice in a separate section;
3. residual risks or checks that were not run.

If there are no findings, say so explicitly. Write permission: none.

## Document

Choose the destination in this order:

1. the user's explicit path;
2. an existing planning document in the coordination root;
3. the current approved FuseForge or product stage artifact;
4. stop and ask if the destination is still unclear.

Inspect relevant current artifacts before documenting implemented behavior.
Separate current facts, proposed decisions, risks, and Open Questions. Do
not describe a proposal as completed work.

Write permission: one planning document. Update a directly required index or
link only when the user requested it or project rules require it. Never
write product source, specialist source, tests, configuration, CI, or
dependencies.

## Prohibited

- Never implement product behavior or change specialist source.
- Never create a shared contract, workspace, or `.craft/fuseforge/` state.
- Never settle a silent track, stack, or topology.
- Never apply Review findings or Proposal recommendations in the same
  request.
- Never write a document without explicit document wording.
- Never manufacture evidence or present inference as observed fact.
- Never collapse required workflow stages or their human checkpoints.
- Never emit Craft's `Assumptions` or `Selection Gate` from Consult.
- Never claim a specialist Consult was executed.

## Completion

Report the selected mode, evidence inspected, files written (normally none),
open questions, and the next command if Craft is needed.

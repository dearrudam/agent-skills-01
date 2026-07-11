---
name: sdd4j-ears-tests
description: Generate traceable Java tests from SDD4J EARS requirements. Use with SDD4J when package-info.java capability specs have ## Requirements groups with ids like R1.1 and tests must be parameterized, table-driven, or otherwise grep-traceable to each statement. Trigger on SDD4J tests, EARS tests for Java, tests from package-info.java requirements, requirement id traceability, or converting SDD4J requirements into tests.
metadata:
  type: test-generation
---

# Skill: SDD4J EARS Tests

## Objective

Turn SDD4J EARS requirement statements into traceable Java tests. This skill owns only the EARS-to-test transform and the requirement trace. The architecture adapter owns where capability code and tests belong. The stack skill owns concrete test syntax, runner, fixtures, and verification.

## Input Contract

Consume a SDD4J capability spec, usually from `package-info.java`, with this shape:

```md
## Boundary

- `place-order` - Places an order for a valid cart.

## Requirements

### R1 Place order

- R1.1 When a cart with at least one item is submitted, the capability shall create and confirm an order.
  
- R1.2 If the cart is empty, then the capability shall reject the request.

```

Do not edit the spec and do not coin requirement ids. Missing, duplicate, or malformed ids are spec issues to report back to SDD4J.

## Core Mapping

- One requirement group `Rn` maps to one parameterized, table-driven, or grouped test skeleton when the group has multiple statements.
- One statement `Rn.m` maps to one labeled row, case, or test title.
- The statement id `Rn.m` must be grep-visible in the test source.
- The row label, display name, method name, JavaDoc, or annotation must preserve the id exactly.
- A removed id retires its row. A row with no matching statement is drift.

The shared test body should exercise the boundary operation or application operation associated with the requirement group, as defined by SDD4J and the architecture adapter.

## EARS Pattern To Case Shape

Each EARS statement decomposes into arrange, act, assert, and role fields. Do not invent concrete values from prose; use clear TODO/failing stubs when values or assertions are not derivable from existing code or user input.

| Pattern | Statement shape | Arrange | Act | Assert | Role |
| --- | --- | --- | --- | --- | --- |
| Event-driven | `When <trigger>, the capability shall <response>` | default state | trigger | response | happy |
| Unwanted behavior | `If <trigger>, then the capability shall <response>` | default state | invalid trigger | rejection/error | unhappy |
| State-driven | `While <precondition>, the capability shall <response>` | precondition | implicit | response | stateful |
| Complex | `While <precondition>, when <trigger>, the capability shall <response>` | precondition | trigger | response | full tuple |
| Optional-feature | `Where <feature is included>, the capability shall <response>` | feature enabled | trigger or implicit | response | gated |
| Ubiquitous | `The capability shall <response>` | default or global state | implicit | invariant | invariant |

Mixing happy and unhappy rows in one group is normal when they share the same operation skeleton.

## Deterministic vs Authored

Generate without judgment:

- Group-to-test skeleton.
- Statement-to-row mapping.
- Requirement id labels.
- EARS role classification.
- Bijection checks between spec ids and test ids.
- The shared operation target when SDD4J and the architecture adapter already identify it.

Leave authored or explicit TODOs for:

- Concrete fixture values.
- Domain object construction when not already obvious.
- Exact assertion expression for prose responses.
- Error type, status code, or message when the spec does not define it.

Prefer a failing TODO, disabled placeholder with a visible reason, or stack-idiomatic red test over a fabricated green assertion.

## Composition

- SDD4J owns the spec, stable ids, gap workflow, and drift policy.
- The architecture adapter owns whether the operation is a controller method, application service method, BCE boundary method, listener, command, or another entrypoint.
- The stack skill owns test syntax and the verification command.
- This skill consumes `## Requirements` and emits or updates tests with grep-visible ids.

During `/sdd4j apply`, use this skill when an `Rn.m` statement lacks a test trace or when a requirement group should be represented as table-driven tests.

## Realization Rules

Read `references/realizations.md` when concrete examples are useful. Use the project's existing test idiom; never introduce a second framework or style just because an example uses it.

For Java stacks, common realizations are:

- JUnit 5: `@ParameterizedTest` with `@MethodSource`, `@CsvSource`, or existing project convention.
- zunit or zero-dependency tests: a loop over a case record/list where the id appears in assertion messages.
- Plain tests: acceptable for one-statement groups if the id appears in the method name, display name, JavaDoc, or annotation.

## Bijection Check

Before and after editing tests, check:

- Every `Rn.m` in the spec appears in at least one test trace.
- Every test trace matching `R\d+\.\d+` belongs to an existing statement in that capability spec.
- One statement can have multiple tests only when each test covers a distinct level or scenario and the duplication is intentional.
- A test must not claim an id from another capability unless the project explicitly has cross-capability system tests.

Report orphan test ids as drift. Do not edit the spec to absorb orphan ids.

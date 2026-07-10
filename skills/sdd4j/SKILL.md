---
name: sdd4j
description: Spec-Driven Development for Java workflow using package-info.java as the co-located capability contract. Use when the user asks for SDD4J, spec-driven Java development, package-info.java specs, EARS requirements, traceable requirement tests, or wants to set up, create, apply, or verify Java capability specs across architectures such as sdd4j-package-by-feature, sdd4j-package-by-layer, or sdd4j-bce.
metadata:
  type: workflow
---

# Skill: SDD4J

## Objective

Drive Spec-Driven Development for Java without owning the project's architecture. SDD4J owns the workflow, the spec format, and traceability. The composed architecture skill owns how a capability maps to code. The composed stack skill owns Java idioms, build, run, and test verification.

Use SDD4J as:

```text
/sdd4j setup
/sdd4j new <capability-or-feature>
/sdd4j apply <capability>
/sdd4j verify <capability>
```

If the user clearly asks for this workflow without slash syntax, infer the matching mode.

## Core Invariants

- The spec is the capability contract: what the Java package promises, not how it is implemented.
- The spec lives in `package-info.java` using Markdown doc comments ([JEP 467](https://openjdk.org/jeps/467)) - each line prefixed `///`, ending with the `package …;` declaration; if the project does not support it then use conventional Javadoc, ending with the `package …` declaration;
- One capability spec maps to one architecture-defined component, feature, package, module, or business component.
- One spec per capability is the single source of truth. Never create parallel specs for one capability.
- A project should have one primary SDD4J architecture adapter. Multiple adapters in one repository are exceptional and must be declared explicitly per module, package root, or capability set in `AGENTS.md`.
- The task list is the current gap between spec, code, and tests. Read it on demand; do not maintain a separate task file.
- `## Requirements` uses EARS statements with stable ids such as `R1.1`.
- Every requirement id must be grep-visible in at least one test according to the stack or project trace convention.
- Done means the stack verification is green and no structural gap or drift remains.
- SDD4J does not prescribe `boundary/control/entity`, `controller/service/repository`, or any other layout.
- SDD4J must obey stronger invariants imposed by the selected architecture adapter. Do not weaken an adapter's contract to make an existing project fit silently.

## Composition Model

Resolve three roles before writing or applying code:

```text
SDD4J workflow
  spec format, setup/new/apply/verify, EARS, traceability, gap loop

Architecture adapter
  package layout, capability location, operation mapping, entity/model mapping, drift rules

Stack skill
  Java framework conventions, build tool, test command, runtime verification
```

Examples:

```text
sdd4j + sdd4j-package-by-feature + spring-boot-server
sdd4j + sdd4j-package-by-layer + spring-boot-server
sdd4j + sdd4j-package-by-feature + microprofile-server
sdd4j + sdd4j-bce + java-cli-app
```

## Architecture Adapter Contract

The architecture skill or the project's `AGENTS.md` must answer these questions:

- What is the project's primary SDD4J architecture adapter?
- Are there any explicitly declared exceptions by module, package root, or capability set?
- Where is the source root?
- Where does a capability's `package-info.java` live?
- How does a capability name map to packages and classes?
- How do `## Boundary` operations map to entrypoints or application operations?
- How do `## Entities` entries map to domain, model, entity, aggregate, DTO, or persistence classes?
- Which implementation areas are intentionally not part of the spec?
- How is structural drift detected in both directions?
- How do tests expose requirement ids?

If the adapter cannot answer confidently, run `setup` or ask one specific question. Do not infer a complex architecture silently.

Treat architecture as a project-level decision, not a per-capability preference. Use one primary adapter for the project or module. If a repository genuinely mixes architectures, `AGENTS.md` must declare the routing rule before SDD4J writes, applies, or verifies affected capabilities. Never mix adapters inside one capability.

## Project Configuration

Prefer a project-local `## SDD4J` section in `AGENTS.md` when the project does not follow an adapter's defaults exactly.

Use this shape and keep it concise:

```md
## SDD4J

Spec source:
- format: `package-info.java`
- source root: `src/main/java`
- requirements style: EARS
- trace ids: `R<n>.<m>`

Architecture layout:
- skill: `sdd4j-package-by-feature`
- scope: primary project architecture
- capability package pattern: `com.acme.<capability>`
- test package mirrors main package: true

Stack:
- skill: `spring-boot-server`
- build tool: Maven
- verification command: `./mvnw test`

Traceability:
- requirement id must appear in test method name, display name, JavaDoc, or annotation
```

For sdd4j-package-by-layer projects, include explicit layer package roots and the capability mapping convention. For mixed or transitional repositories, include a short `architecture routing` rule that maps package roots or modules to adapters.

## System Doc

An optional system doc can live one package above the capability packages, usually as the base package's `package-info.java`. Use it only for concerns that span capabilities and have no better home. A one-capability system does not need it.

Recommended sections:

- `## Charter` - one sentence for the whole Java application or module.
- `## Vision` - optional aspirational sentence; rationale only, not a testable contract.
- `## Components` - declared wiring between capabilities, modules, adapters, or external systems.
- `## System invariants` - cross-capability EARS `shall` statements using ids such as `S1` or `S1.1`.
- `## Ubiquitous language` - shared domain nouns that should not be redefined in every capability.
- `## Stack` - composed stack skill, architecture adapter, source root, and base package when useful.

Do not duplicate every capability's one-line responsibility in hand-written system docs. If a capability map is needed, mark it generated and regenerate it from capability specs.

## README Projection

An optional repo-root `README.md` is a projection of specs, not a source of truth after specs exist.

Generated content, if present, must be fenced by:

```html
<!-- sdd4j:generated:start -->
<!-- sdd4j:generated:end -->
```

The generated block may include the system Charter and Vision, a capability map with links to `package-info.java`, and a Mermaid diagram of declared `## Components` wiring. Render only declared wiring from the system doc. Never infer component edges by scanning code.

Hand-maintained README sections outside the generated block are allowed for conventions, build/run/test instructions, license, links, and motivation. `## Conventions` is for non-behavioral project standards and is not tested. Behavioral invariants belong in a capability spec or system doc requirement.

When `/sdd4j new` has no capability argument, the hand-written README prose outside generated markers may be used as an inception seed. Read it, propose capability decomposition and a possible `## Vision`, then ask for confirmation before writing specs. Once specs exist, they are authoritative; do not keep README prose in sync.

## Determinism Boundary

| Concern | Owner | Deterministic? |
| --- | --- | --- |
| Run verification | Stack skill or configured project command | Yes |
| Locate code and map architecture | Architecture adapter plus `AGENTS.md` | Mostly deterministic |
| Decompose natural-language feature into capabilities | SDD4J judgment, user-confirmed | No |
| Author boundary operations and EARS statements | SDD4J judgment, user-confirmed when ambiguous | No |
| Place packages and classes | Architecture adapter plus stack skill | Yes when configured |
| Structural sync both directions | SDD4J using adapter rules and grep-visible ids | Mostly deterministic |
| Decide if code satisfies a requirement | SDD4J judgment grounded by passing tests | No |
| Regenerate README generated block | SDD4J from package docs | Yes |

Ask the stack skill or configured command whether the project is green. Do not self-certify convergence.

## Mode: setup

Use `setup` to configure SDD4J for an existing Java project before creating specs.

Workflow:

1. Inspect project files enough to identify Java source roots, build tool, likely stack, and likely layout.
2. Detect or ask for the primary architecture layout: `sdd4j-package-by-feature`, `sdd4j-package-by-layer`, `sdd4j-bce`, or a project-specific mapping.
3. Detect or ask for the stack skill: Spring Boot, MicroProfile, Java CLI, or another Java stack.
4. If multiple layouts appear, treat that as exceptional. Ask whether the project is transitional or multi-module, then propose explicit architecture routing by module, package root, or capability set.
5. Propose the `## SDD4J` section for `AGENTS.md`.
6. Ask for confirmation before writing or replacing that section.
7. Write only the project mapping. Do not create capability specs or domain code during setup.

When confidence is low, ask one concrete question at a time. Prefer enumerable choices with room for a custom answer.

## Mode: new

Use `new` to declare a capability spec from a precise capability name, a natural-language feature description, or a README seed when no argument is provided. Coining a capability and extending an existing one are both valid `new` work because the novelty is the intended behavior.

Clarify before authoring:

- Loop until every contract ambiguity is resolved. Each answer can expose a new gap.
- Never assume silently. If leaning on a default, name it and ask for confirmation.
- Ask one concrete ambiguity per question. Prefer specific options with room for a custom answer.
- Interrogate each boundary operation for trigger, response, invalid triggers, state constraints, entities, identity, validation, lifecycle scope, and what done means.
- Stop only when another engineer could author the same spec from the user's words. If not, ask one more focused question.

For a capability name:

1. Validate the name using the architecture adapter's naming rules.
2. Locate the target package from `AGENTS.md` or the architecture adapter.
3. If `package-info.java` exists, do not overwrite it without explicit user confirmation.
4. Clarify boundary operations, entities, happy paths, edge cases, and out-of-scope behavior until the contract is answerable from user intent.
5. Author the package spec from the required section order.
6. Ask the architecture and stack skills to scaffold only what their conventions require. Do not invent application behavior beyond the spec.
7. Report the open gap: operation count, requirement count, entity count, and suggested `/sdd4j apply <capability>`.

For a feature description:

1. Scan existing package specs and architecture mapping.
2. Propose one or more capabilities to create or extend. Tag each as `new` or `extend-existing` and include the one-line responsibility.
3. Ask the user to confirm the decomposition before writing.
4. Apply the capability-name workflow to each approved capability. Extend the single existing package spec for existing capabilities; never create a second spec.
5. If decomposition introduces cross-capability wiring, shared language, or system invariants, propose a system doc update and ask before writing it.

For a README seed:

1. Read only hand-written prose outside `sdd4j:generated` markers.
2. Treat it as a feature description and run the feature-description workflow.
3. Propose a `## Vision` line distilled from the seed for user acceptance or editing.
4. Leave the seed prose human-owned. Do not rewrite it except for the generated block when explicitly requested.

## Mode: apply

Use `apply` to converge code and tests to an existing capability spec.

Workflow:

1. Locate the capability's `package-info.java`; if missing, stop and suggest `/sdd4j new <capability>`.
2. Resolve the applicable architecture and stack from `AGENTS.md`, system package docs, repository conventions, or one focused question. If multiple adapters could apply, stop until the routing rule is explicit.
3. Run the stack verification loop before editing when feasible. If green and no structural gap exists in either direction, stop and report already converged.
4. Read the structural gap both ways.
5. Close spec-to-code gaps: each missing operation becomes the adapter-defined operation; each untested `Rn.m` gets a traceable test; each declared entity gets the adapter-defined representation when needed.
6. Delegate EARS-to-test mapping to `sdd4j-ears-tests` when available: one parameterized or table-driven test per `### Rn` group and one labeled row or case per statement id `Rn.m`, adapted to the stack's test framework.
7. Write the correct implementation to pass the new tests.
8. Surface code-to-spec drift instead of silently editing the spec to match code. The user decides whether to declare it or delete the orphan.
9. Re-run verification and repeat for at most three passes. Then surface remaining failures, gaps, or drift.

Stop when verification is green and no gap or drift remains.

## Mode: verify

Use `verify` to check conformance without intentionally implementing missing behavior.

Report:

- Spec location.
- Resolved architecture adapter, routing rule, and stack.
- Requirement ids with and without tests.
- Boundary operations with and without mapped code.
- Entities/models with and without mapped code.
- Inverse drift found in code or tests.
- Verification command and result.

## Spec Format

Sections must appear in this order:

```md
# Capability Title

> One sentence responsibility.

## Boundary

- `operation-name` - Transport-neutral operation description.

## Requirements

### R1 Requirement group title

- R1.1 When <trigger>, the capability shall <response>.
- R1.2 If <unwanted condition>, then the capability shall <response>.

## Entities

- EntityName - Contract-relevant meaning.

## Out of scope

- Explicit non-goal.
```

`## Entities` and `## Out of scope` are optional, but include them when they prevent ambiguity.

Boundary operations must be verb-noun and transport-neutral, such as `place-order`, not `POST /orders` or `click-submit`.

## EARS Rules

- Use `shall` for every requirement.
- Use stable ids and never reuse retired ids.
- Keep statements behavioral and verifiable.
- Keep framework details, URLs, HTTP verbs, database tables, and implementation choices out of requirements unless the stack contract itself is the capability.
- Use `When`, `If`, `While`, `Where`, or ubiquitous EARS statements.
- Every boundary operation must trace to a requirement group `Rn`.
- Every statement `Rn.m` must trace to at least one test that embeds the id according to the stack convention.
- A test id with no matching statement is inverse drift.
- Optional behavior is expressed with `Where <feature is included>, the capability shall <response>.` Do not use `should` or `may` for contract behavior.

EARS templates:

| Pattern | Template |
| --- | --- |
| Ubiquitous | `The capability shall <response>.` |
| State-driven | `While <precondition>, the capability shall <response>.` |
| Event-driven | `When <trigger>, the capability shall <response>.` |
| Optional-feature | `Where <feature is included>, the capability shall <response>.` |
| Unwanted behavior | `If <trigger>, then the capability shall <response>.` |
| Complex | `While <precondition>, when <trigger>, the capability shall <response>.` |

## Optional Why

Any boundary operation or `Rn.m` statement may carry a trailing `_(why: ...)_` note.

Rules:

- The `why` explains origin or intent, not current implementation.
- The `why` is rationale, not contract, and is not tested.
- The id must remain first so grep-visible traceability still works.
- A `why` retires with its operation or statement and must not become an orphan.

## Drift Policy

The spec is source of truth for intended behavior. SDD4J can implement missing declared behavior, but it must not auto-expand the spec to bless existing code. When code exists without a spec counterpart, report it as drift and ask whether to declare it or remove it.

Spec-to-code gaps are work SDD4J may close:

- Missing mapped operation for a declared boundary operation.
- Missing mapped representation for a declared entity when the adapter says it should exist.
- Missing test trace for a requirement id.
- Failing behavior for a declared requirement.

Code-to-spec drift is user-decision territory:

- Mapped entrypoint or application operation absent from `## Boundary`.
- Contract-relevant domain/model/entity artifact absent from `## Entities`.
- Test tracing an id no statement carries.
- Behavior that expands the capability beyond the spec.

Never edit the spec merely to absorb drift. Ask whether to declare the behavior or remove the orphan.

---
name: migrate-to-bce
description: Plan and execute incremental migrations of existing projects to Boundary-Control-Entity (BCE/ECB) architecture. Use when the user wants to port, migrate, refactor, restructure, reorganize, or convert an existing codebase to BCE, Boundary-Control-Entity, ECB, business components, or boundary/control/entity layers. Always use this before changing code for BCE migration requests, even when another stack skill such as SBCE, SDD4J, Java, Spring, Quarkus, web components, or MicroProfile will also be needed.
metadata:
  type: migration-workflow
---

# Skill: Migrate To BCE

## Objective

Guide safe, incremental migration of an existing project to Boundary-Control-Entity architecture. This skill owns the migration workflow: discovery, target component model, migration plan, and convergence steps. Technology-specific implementation, build, tests, and framework idioms belong to composed stack skills.

Use this skill with a BCE architecture skill when available. Use SBCE or SDD4J when the migration also needs capability specs, requirement traceability, or spec-driven convergence.

## Core Rule

For any BCE migration request, produce a migration plan before editing code unless the user explicitly says a plan already exists and asks to execute a specific step.

The plan is important because migrating to BCE changes ownership boundaries, not just folders. A safe migration must identify business responsibilities first, then move behavior without changing observable behavior.

## Operating Modes

Classify the user request into one mode:

- `assess`: inspect the current architecture and explain BCE migration fit.
- `plan`: create a migration plan with proposed business components and steps.
- `apply`: execute one approved migration step from an existing plan.
- `verify`: check whether migrated code follows the plan and BCE rules.

Default to `plan` when the user asks to migrate, port, convert, or refactor to BCE. Default to `assess` when the user asks whether BCE fits or asks for advice only.

## Discovery Workflow

Before planning, inspect the repository enough to understand its shape:

- Read project guidance files such as `AGENTS.md`, `CLAUDE.md`, architecture docs, README files, and package/module conventions.
- Identify the build system, source roots, test roots, and major modules.
- Identify current architectural style: package-by-layer, package-by-feature, MVC, hexagonal, CRUD services, scripts, monolith, or mixed layout.
- Identify externally visible entry points: APIs, CLIs, UI routes, jobs, message handlers, controllers, resources, handlers, or exported functions.
- Identify domain nouns, use cases, persistent entities, repositories, services, policies, and integrations.
- Identify existing tests and the command that verifies behavior.
- Identify test files that exercise each source file, entry point, use case, or component, including unit, integration, system, contract, and characterization tests.

Use the smallest investigation that can support a credible plan. Do not rewrite or move files during discovery.

## BCE Target Model

Use these BCE rules for migration decisions:

- A business component is named after a business responsibility, capability, or shared domain concern.
- A component may have `boundary`, `control`, and `entity` layers, but not every component needs every layer.
- Boundary owns external entry points, protocol adapters, UI/event adapters, facades, authorization wrappers, transactions, and request/response mapping.
- Control owns procedural business logic, orchestration, policies, and use-case coordination.
- Entity owns domain state, invariants, value objects, domain behavior, and persistence-facing domain objects where applicable.
- Shared technical utilities are not business components unless they carry reusable domain or protocol semantics.
- Avoid naming components after technical layers such as `controller`, `service`, `repository`, `dto`, `util`, or `config`.

Prefer preserving existing names when they already express a responsibility. Rename only when the current name is misleading or purely technical.

## Test Migration Rule

Tests are part of BCE convergence, but usually move last within each migration slice.

For each approved migration step:

1. Move production code first.
2. Update imports, configuration, registration, and wiring until the project compiles.
3. Run the relevant tests to confirm behavior is preserved before relocating tests when feasible.
4. Move the directly associated tests to mirror the new BCE component and layer when the project uses mirrored test packages or component ownership.
5. Run the relevant or full verification command again after test relocation.

A migration slice is not complete until:

- production code is under the intended BCE component and layer,
- directly associated tests are under the corresponding BCE test package when local conventions allow it,
- the project compiles,
- and the relevant or full test suite passes.

Do not report a BCE migration step as complete if tests still live in obsolete technical-layer packages, unless a stronger project-local test convention explicitly requires that layout.

## Spec Reverse Engineering Prompt

When `sbce` or `sdd4j` skills are available in the environment, add one explicit post-migration decision point after BCE code and tests are green:

- Ask whether the user wants to reverse engineer the migrated business components into capability specs, preparing the project to use SBCE or SDD4J workflows.

Do not generate specs automatically. Ask one focused question and offer the available options:

- use `sbce` when the user wants one capability spec per business component and spec-driven BCE convergence,
- use `sdd4j` when the user wants Java `package-info.java` capability specs, EARS requirements, or traceable requirement tests,
- skip spec reverse engineering for now.

If the user chooses spec reverse engineering, compose this skill with the selected spec workflow skill and treat the generated specs as a separate follow-up migration step. Preserve the already-green BCE migration state.

## Migration Plan Output

When producing a plan, use this structure:

```md
## BCE Migration Plan

### Current Shape
[Brief description of the current architecture and verification command if known.]

### Proposed Business Components
| Component | Responsibility | Boundary | Control | Entity | Source Evidence |
| --- | --- | --- | --- | --- | --- |

### Migration Strategy
[Incremental strategy and sequencing rationale.]

### Steps
1. [Small, behavior-preserving migration step.]
2. [Next step.]

### Risks And Checks
| Risk | Check |
| --- | --- |

### Recommended First Step
[The smallest useful step to apply if the user wants to continue.]
```

Keep the plan concrete. Reference actual packages, directories, files, classes, modules, or routes discovered in the repository.

## Planning Heuristics

Create steps that are small enough to verify independently:

- Start with one low-risk component or one vertical slice, not the whole codebase.
- Prefer moving code before renaming code when both are needed.
- Prefer introducing component directories/packages before changing behavior.
- Preserve public APIs, routes, CLI commands, data formats, database schemas, and persisted data unless the user approves a breaking change.
- Keep adapters at the edge and business rules in control/entity layers.
- Leave mixed or transitional layouts explicit rather than pretending the migration is complete.
- When tests are weak, add characterization tests or document manual checks before moving risky behavior.
- Treat tests as part of the migration unit. Moving production code without moving its directly associated tests is incomplete when tests mirror source structure or component ownership.
- Prefer moving tests after production code is stable in the new package, so behavior failures and test-package relocation failures are not mixed together.

Do not create compatibility shims unless there is a concrete need: external consumers, persisted data, shipped behavior, or explicit user requirement.

## Applying A Migration Step

Only apply code changes when the user asks to execute a plan or a specific migration step.

When applying:

1. Restate the selected step briefly.
2. Inspect the touched files before editing.
3. Move or refactor the minimum code needed for that step.
4. Preserve behavior and public contracts.
5. Update imports, package/module declarations, registration/configuration, and wiring affected by the move.
6. Run the relevant formatter/build/tests when available to confirm production behavior is still preserved.
7. Move directly associated tests to the corresponding BCE component/layer test package when local conventions allow mirrored tests.
8. Run the relevant or full verification command again after test relocation.
9. If `sbce` or `sdd4j` skills are available and the migrated BCE slice is green, ask whether to reverse engineer migrated BCs into capability specs for SBCE or SDD4J.
10. Report what changed, what was verified, what tests moved, the user's spec reverse-engineering decision when asked, and what remains transitional.

If the repository has uncommitted unrelated changes, do not revert or rewrite them. Work around them unless they directly conflict with the selected step.

## Verification

For `verify` mode, check both structure and behavior:

- Components are named after responsibilities.
- `boundary`, `control`, and `entity` appear only inside business components.
- External entry points live in boundary or call a boundary facade when one is justified.
- Procedural business logic is not stranded in controllers, handlers, DTOs, repositories, config classes, or root packages.
- Domain state and invariants are in entity types where the stack supports that shape.
- Cross-component dependencies are intentional and minimal.
- Tests or documented checks cover the migrated behavior.
- Migrated production code has matching migrated tests in the corresponding BCE test package when local conventions allow mirrored tests.
- The project compiles and the relevant or full test suite passes after both production-code relocation and test relocation.
- When `sbce` or `sdd4j` skills are available, the user has been asked whether to reverse engineer migrated BCs into specs, or the report explicitly notes that this follow-up was not requested.

Report gaps as actionable follow-up steps. Do not silently expand the migration scope while verifying.

## Composition

Compose this skill with:

- `bce` for detailed Boundary-Control-Entity architectural rules when available.
- `sbce` when the user wants one capability spec per business component, spec-driven BCE convergence, or reverse engineering migrated BCs into capability specs.
- `sdd4j` and `sdd4j-bce` for Java projects using `package-info.java` specs, EARS requirements, traceable tests, or reverse engineering migrated Java BCE components into co-located specs.
- The relevant stack skill for language, framework, build, test, and runtime conventions.

This skill does not override stronger project-local instructions in `AGENTS.md` or an existing architecture decision record. Surface conflicts and ask one focused question when the migration target is ambiguous.

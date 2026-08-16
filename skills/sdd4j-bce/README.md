# SDD4J BCE Skill

Maps an SDD4J Java capability spec to a Boundary-Control-Entity business component.

## When To Use

Use this architecture adapter when a Java project organizes capabilities as BCE business components with component-local `boundary`, `control`, and `entity` layers.

Compose it with `sdd4j` for the spec workflow and a Java stack skill for implementation conventions and verification. Use it only when each capability can map to one strict BCE business component.

## Mapping

```mermaid
flowchart LR
  A[SDD4J capability] --> B[BCE business component]
  B --> P[package-info.java spec]
  P --> BO[Boundary operations]
  P --> R[Requirements]
  P --> E[Entities]
  BO --> BL[boundary layer]
  R --> T[Exact runner-visible trace tests]
  E --> EL[entity layer]
  B --> CL[control layer]
  CL -. implementation detail .-> R
```

## Default Layout

```text
src/main/java/<base>/<component>/
  package-info.java
  boundary/
  control/
  entity/
```

## Core Rules

- One SDD4J capability maps to one BCE business component.
- `## Boundary` maps only to boundary-layer operations.
- `## Entities` maps to contract-relevant types in the entity layer.
- `control` is implementation detail and has no spec section.
- Requirement ids must resolve to exact runner-visible test identities through literal ids or resolvable symbols according to the stack convention; JavaDoc and comments alone do not count.
- Public boundary operations, contract-relevant entity types, or test traces without spec counterparts are reported as inverse drift.
- Cross-component calls, events, shared nouns, and system invariants belong in the system package doc or project architecture documentation.
- Do not mix BCE, feature-package, and layered adapters inside one capability.

## Source Contract

See [`SKILL.md`](SKILL.md) for the executable skill instructions.

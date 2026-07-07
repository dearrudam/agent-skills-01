# Migrate To BCE Skill

Plans and applies incremental migrations from an existing architecture to Boundary-Control-Entity architecture without changing observable behavior unnecessarily.

## When To Use

Use this skill when the user asks to migrate, port, refactor, restructure, reorganize, or convert a codebase to BCE, ECB, business components, or `boundary/control/entity` layers.

## Workflow

```mermaid
flowchart TD
  A[User requests BCE migration] --> B{Mode}
  B -->|assess| C[Inspect current architecture]
  B -->|plan| D[Discover source roots, entrypoints, domain nouns, tests]
  B -->|apply| E[Execute one approved migration step]
  B -->|verify| F[Check BCE structure and behavior]
  C --> G[Report BCE fit]
  D --> H[Produce migration plan]
  H --> I[Approved step]
  I --> E
  E --> J[Run relevant verification]
  J --> K[Move matching tests when convention allows]
  K --> L[Run verification again]
  F --> M[Report gaps]
```

## Migration Model

```mermaid
flowchart LR
  R[Business responsibility] --> BC[Business component]
  BC --> B[boundary]
  BC --> C[control]
  BC --> E[entity]
  B --> X[External entrypoints and adapters]
  C --> U[Use-case coordination and policies]
  E --> D[Domain state and invariants]
```

## Core Rules

- Produce a migration plan before changing code unless an approved plan already exists.
- Identify business responsibilities before moving folders.
- Preserve public APIs, routes, schemas, data formats, and shipped behavior unless the user approves a breaking change.
- Move directly associated tests as part of each migration slice when project conventions allow mirrored ownership.
- Compose with stack skills for build, test, framework, and language rules.

## Source Contract

See [`SKILL.md`](SKILL.md) for the executable skill instructions.

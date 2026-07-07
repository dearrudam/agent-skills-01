# SDD4J EARS Tests Skill

Generates traceable Java tests from SDD4J EARS requirement statements.

## When To Use

Use this skill when `package-info.java` capability specs contain `## Requirements` groups with ids like `R1.1` and tests must be parameterized, table-driven, or grep-traceable.

## Transform

```mermaid
flowchart LR
  A[package-info.java] --> B[Requirements groups]
  B --> C[Requirement group Rn]
  C --> D[Parameterized or grouped test]
  C --> E[Statement Rn.m]
  E --> F[Labeled row, case, display name, or method]
  F --> G[Grep-visible requirement id]
```

## Composition

```mermaid
flowchart TD
  S[SDD4J] --> A[Spec and stable ids]
  M[Architecture adapter] --> B[Test location and operation target]
  T[Stack skill] --> C[Test framework and verification command]
  A --> D[Traceable tests]
  B --> D
  C --> D
```

## Core Rules

- One requirement group maps to one parameterized, table-driven, or grouped test skeleton when appropriate.
- One statement id maps to one labeled row, case, display name, method name, JavaDoc, or annotation.
- Preserve the requirement id exactly in test source.
- Do not coin requirement ids or edit the spec.
- Report orphan test ids as drift.

## Source Contract

See [`SKILL.md`](SKILL.md) for the executable skill instructions.

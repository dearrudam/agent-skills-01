# MicroProfile Server Skill

Defines stack-specific coding rules for long-running Java MicroProfile / Jakarta EE server applications while preserving the project's selected architecture.

## When To Use

Use this skill when creating, generating, scaffolding, writing, migrating, troubleshooting, or reviewing MicroProfile / Jakarta EE server code.

## Composition

```mermaid
flowchart LR
  A[MicroProfile Server skill] --> B[JAX-RS, CDI, JSON-P, validation]
  A --> C[Persistence, configuration, observability, security]
  A --> D[MicroProfile testing strategy]
  E[Architecture skill] --> F[Package and component layout]
  G[Java conventions] --> H[Language-level style]
  B --> I[Project change]
  C --> I
  D --> I
  F --> I
  H --> I
```

## Request Flow

```mermaid
flowchart TD
  A[MicroProfile task] --> B[Read project guidance and existing conventions]
  B --> C{Architecture specified?}
  C -- yes --> D[Compose with architecture skill]
  C -- no --> E[Preserve current organization]
  D --> F[Make smallest stack-aligned change]
  E --> F
  F --> G[Run relevant tests unless skipped explicitly]
```

## Core Rules

- Treat MicroProfile as the application stack, not the architecture.
- Preserve existing package organization unless the user asks for an architecture change.
- Prefer JAX-RS `WebApplicationException` subclasses and `ExceptionMapper` for HTTP errors.
- Keep business logic out of JAX-RS resources and transport details out of application/domain code.
- Use existing project dependency, test, JSON, validation, and configuration conventions.

## Source Contract

See [`SKILL.md`](SKILL.md) for the executable skill instructions.

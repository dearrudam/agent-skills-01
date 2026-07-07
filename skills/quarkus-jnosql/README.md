# Quarkus JNoSQL Skill

Guides Quarkus applications that use Quarkus JNoSQL, Eclipse JNoSQL, Jakarta NoSQL, or Jakarta Data repositories while treating the official documentation as the source of truth.

## When To Use

Use this skill for Quarkus JNoSQL creation, review, migration, troubleshooting, dependency setup, repository usage, template usage, database-specific setup, and native-image questions.

## Workflow

```mermaid
flowchart TD
  A[User request] --> B[Classify intent]
  B --> C{Database known?}
  C -- no and required --> D[Ask for target database]
  C -- yes --> E[Read doc navigation]
  D --> E
  E --> F[Fetch smallest relevant official section]
  F --> G[Apply dependency version policy]
  G --> H[Generate minimal solution]
  H --> I[Return validation checklist]
```

## Documentation Policy

```mermaid
flowchart LR
  A[Official Quarkus JNoSQL docs] --> B[Current guidance]
  B --> C[Dependency and configuration snippets]
  B --> D[Repository and Template examples]
  B --> E[Database-specific notes]
  F[Fallback patterns] -. only when docs unavailable .-> C
```

## Core Rules

- Prefer current official docs over embedded examples.
- Retrieve only the smallest section needed for the request.
- Preserve existing project BOMs, catalogs, and versions.
- Do not infer extension versions from memory, caches, snapshots, or unrelated examples.
- Verify database-specific support for Jakarta Data, Template type, and native compilation.

## Source Contract

See [`SKILL.md`](SKILL.md) for the executable skill instructions.

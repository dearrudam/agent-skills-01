---
name: quarkus-jnosql
description: Use this skill when the user wants to create, review, migrate, troubleshoot, or explain Quarkus applications using the Quarkus JNoSQL extension, Eclipse JNoSQL, Jakarta NoSQL, or Jakarta Data repositories.
---

# Quarkus JNoSQL Skill

This skill enables agents to help with Quarkus JNoSQL while avoiding stale embedded documentation.

## Source of truth

The official documentation is the source of truth:

https://docs.quarkiverse.io/quarkus-jnosql/dev/index.html

Before generating dependency snippets, configuration, database-specific setup, Repository examples, Template examples, native-image guidance, or troubleshooting advice, consult the relevant section of the official documentation whenever browsing or retrieval is available.

Do not copy the entire documentation into the answer. Retrieve only the smallest relevant section, summarize what was loaded, then generate the requested result.

## Dependency version policy

Treat artifact selection and version selection as separate decisions. The target database determines the extension artifact, but it does not determine a safe version for the user's project.

Use this precedence when writing Maven or Gradle dependencies:

1. Preserve a version or BOM already present in the user's project.
2. Use a version explicitly supplied by the user.
3. Use an official BOM, platform, catalog, codestart, or documented installation command when the retrieved documentation explicitly provides compatible version management.
4. Otherwise, omit the dependency version and state that it must be managed by the project's existing BOM or extension catalog.

Do not infer a version from local caches, unrelated examples, repository snapshots, previous answers, release memory, or another database extension. Do not introduce a complete Quarkus platform version when the user asked only for essential dependency changes.

## Retrieval budget

Use the smallest investigation that can establish the requested behavior. More searches after the required facts are confirmed increase latency and can introduce conflicting evidence from stale artifacts.

Follow this verification ladder:

1. Read `references/doc-navigation.md` to identify the required sections.
2. Retrieve the relevant sections from the official Quarkus JNoSQL guide, normally the supported-databases table, one feature section, and the matching database section.
3. Stop retrieving when the extension artifact, supported abstraction, NoSQL type, required build configuration, and requested operation are confirmed.
4. Consult one additional official source only when the Quarkus JNoSQL guide explicitly delegates configuration to another extension or leaves a required fact unresolved.
5. If the fact remains unresolved, state the uncertainty and provide the conservative alternative instead of broadening the search indefinitely.

Do not inspect local Maven caches, decompile JARs, scan source repositories, compare snapshots, or search unrelated examples during normal answer generation. Use implementation-level inspection only when the user asks to diagnose an actual local project and the project files or dependency tree are necessary evidence.

## Progressive disclosure workflow

1. Classify the user's intent.
2. Identify the target database, if any.
3. Load only the matching documentation section using `references/doc-navigation.md`.
4. Use `references/fallback-patterns.md` only when documentation access is unavailable or the user explicitly asks for an offline answer.
5. Use `references/troubleshooting-checklist.md` when an error, build failure, CDI issue, repository generation issue, native-image problem, or configuration problem appears.
6. Stop retrieval as soon as the retrieval budget's required facts are confirmed.
7. Apply the dependency version policy before generating build configuration.
8. Generate the smallest working solution.
9. Mention which official documentation section was used when possible.

## Intent routing

- New project or extension installation: load project setup documentation.
- Maven or Gradle dependency: load manual installation documentation.
- Java 21+ build: load annotation processor documentation.
- Entity mapping: load Jakarta NoSQL entity documentation.
- Repository access: load Jakarta Data Repository documentation.
- Template access: load Jakarta NoSQL Template documentation.
- Database-specific setup: load the matching database section.
- Native compilation: load supported database table and the database-specific section.
- Error/debugging: load troubleshooting checklist, then official docs section related to the error.

## Mandatory behavior

- Prefer current official docs over embedded examples.
- Ask for the database only if the task cannot proceed without it.
- If the user already provided the database, do not ask again.
- Do not assume all supported databases have the same features.
- Do not assume all databases support Jakarta Data.
- Do not assume all databases support native compilation.
- Do not invent, guess, or copy an extension version merely because the artifact is database-specific.
- Omit `<version>` when compatible version management cannot be established from the user's project or an explicit official source.
- Do not inspect caches, JAR contents, snapshots, or source repositories merely to increase confidence after official documentation already answers the task.
- Prefer an explicit uncertainty note over unbounded investigation when official documentation does not establish a required detail.
- For Java 21 or newer, verify annotation processor configuration.
- For repositories, verify whether the selected implementation supports Jakarta Data.
- For Template usage, verify the correct NoSQL database type: DOCUMENT, COLUMN, GRAPH, or KEY_VALUE.

## Response style

When answering implementation questions:

1. State the chosen path briefly.
2. Mention the documentation section used.
3. Provide code/configuration.
4. Add a short validation checklist.

When documentation cannot be loaded:

1. Say the answer is based on fallback knowledge.
2. Keep the code conservative.
3. Recommend verifying the official docs before production use.

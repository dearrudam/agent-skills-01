# Documentation Navigation

Use this file to decide which official documentation section to retrieve.

Official documentation:

https://docs.quarkiverse.io/quarkus-jnosql/dev/index.html

## Retrieval limits

Use this file to select sections before retrieving anything. For a normal implementation answer, the expected retrieval scope is:

- `Supported NoSQL Databases` when capability support matters.
- One feature section such as Repository, Template, entities, annotation processing, or native compilation.
- The single matching database section.

Stop once these sections establish the artifact, supported abstraction, database type, build requirement, and requested operation. Do not continue into local Maven caches, JAR inspection, repository source, snapshots, or unrelated examples.

Open one additional official guide only when the Quarkus JNoSQL database section delegates client configuration to that extension. If a required detail still cannot be confirmed, report the uncertainty and use the conservative fallback rather than expanding the search.

## Project creation

Load these sections when the user asks to create a project or start from scratch:

- Getting Started
- Supported NoSQL Databases
- Create your Quarkus JNoSQL Project using Extension Codestarts

## Adding dependencies

Load these sections when the user asks to add Quarkus JNoSQL to an existing project:

- Manually adding Quarkus JNoSQL Extension to your project
- The matching database section

Resolve version management independently from artifact selection:

- Prefer the BOM, extension catalog, or version already present in the user's project.
- Use a documented version only when the official section explicitly establishes compatibility for the requested setup.
- If no compatible source is available, generate the dependency without `<version>` and say that the project BOM or catalog must manage it.
- Do not derive versions from local Maven caches, snapshots, unrelated examples, or another database section.

## Java 21+ / annotation processing

Load this section when the user is using Java 21+, Maven compiler, Gradle compiler, CDI generated classes, or repository generation:

- Enabling the JNoSQL Mapping Lite Annotation Processor

## Jakarta NoSQL entities

Load this section when the user asks for entity mapping:

- Using Jakarta NoSQL and Jakarta Data with Quarkus JNoSQL
- Creating entities using JNoSQL annotations

## Template API

Load this section when the user wants lower-level operations, dynamic persistence, direct insert/update/delete, or Template injection:

- Using Jakarta NoSQL Template

## Jakarta Data Repository

Load this section when the user wants CRUD repositories, method-name queries, custom queries, or repository injection:

- Using Jakarta Data Repository

Also load:

- Supported NoSQL Databases

Use this to verify whether the selected database supports Jakarta Data.

## Database-specific setup

Load the matching database section:

- MongoDB
- Cassandra
- CouchDB
- ArangoDB
- DynamoDB
- Hazelcast
- Elasticsearch
- Solr
- Neo4j
- Oracle NoSQL

## Native compilation

Load:

- Supported NoSQL Databases
- Matching database section

Do not assume native-image support without checking current documentation.

## Troubleshooting

For build or runtime problems, first inspect the error message and then load the most relevant section:

- Annotation processor errors: Enabling the JNoSQL Mapping Lite Annotation Processor
- Repository errors: Using Jakarta Data Repository
- Template errors: Using Jakarta NoSQL Template
- Entity errors: Creating entities using JNoSQL annotations
- Database connection/configuration errors: matching database section
- Native-image errors: Supported NoSQL Databases and matching database section

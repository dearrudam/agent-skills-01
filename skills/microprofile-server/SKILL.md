---
name: microprofile-server
description: Stack-specific coding rules for long-running Java MicroProfile / Jakarta EE server applications, covering JAX-RS resources, CDI, JSON-P, Bean Validation, MicroProfile Config, health/metrics, persistence integration, testing (unit/integration/system), and Maven project conventions. Use whenever creating, generating, scaffolding, writing, migrating, troubleshooting, or reviewing MicroProfile or Jakarta EE server code. This skill is architecture-neutral — compose it with `sdd4j-bce`, `sdd4j-package-by-feature`, `sdd4j-package-by-layer`, or another architecture skill when the project or user specifies an architecture. Also use this skill when the user mentions MicroProfile, Jakarta EE, JAX-RS, Payara, OpenLiberty, Quarkus with MicroProfile, Helidon, WildFly, or similar long-running Java server runtimes. Not for serverless deployments, one-off Java CLI applications, or Spring Boot services.
---

## Composition
- compose with `java-conventions` for all language-level Java rules (syntax, style, naming, visibility, interfaces/classes, methods/lambdas, streams/collections, exceptions, comments/JavaDoc)
- compose with an architecture skill when architecture is specified or already present, such as `sdd4j-bce`, `sdd4j-package-by-feature`, or `sdd4j-package-by-layer`
- when no architecture is specified, infer and preserve the existing project organization instead of introducing BCE, package-by-feature, or package-by-layer by default
- this skill specializes only the MicroProfile / Jakarta EE server stack and does not restate language-level Java or architecture-level rules

## Dependencies
- prefer dependencies in this order: Java SE, MicroProfile APIs, Jakarta EE APIs, and implementations already present in the project
- avoid adding dependencies for problems already solved by MicroProfile, Jakarta EE, Java SE, or the existing project stack
- do not mix multiple JAX-RS/REST implementations unless the existing project already does so deliberately
- ask before changing Maven `pom.xml`, build files, dependency versions, Java version, MicroProfile/Jakarta EE version, or plugin configuration
- prefer a MicroProfile BOM or platform BOM when one is already in use; do not introduce a second platform version unless the user approves

## Architecture Fit
- treat MicroProfile / Jakarta EE as the application stack, not as the architecture
- preserve the architecture already used by the project, including package-by-feature, package-by-layer, BCE, hexagonal, clean, modular monolith, or a local convention
- do not rename packages, introduce architectural layers, or reorganize code solely because this skill is active
- when adding new code, place it where equivalent MicroProfile / Jakarta EE components already live
- when no convention exists, choose the smallest clear structure for the requested change and avoid committing the project to a broad architecture prematurely
- keep framework annotations at application entry points, web/API resources, configuration, adapters, and persistence integration points; avoid leaking transport or framework concerns into domain code unless the project already follows a framework-centric model

## Web/API Entry Points
- place JAX-RS resources, REST clients, health checks, schedulers, messaging listeners, external API clients, and protocol adapters according to the existing architecture
- name JAX-RS resources in plural after the resource they expose, e.g. `SpeakersResource` rather than `SpeakerResource`
- keep resources coarse-grained and free of business logic; validate and translate HTTP input, then delegate to application services, handlers, or use cases
- declare `@Consumes` and `@Produces` at the class level where it clarifies the resource contract; prefer JSON (`jakarta.ws.rs.core.MediaType.APPLICATION_JSON`)
- return `jakarta.ws.rs.core.Response` when status, headers, or empty responses matter; return DTOs or entities directly only for straightforward successful responses
- do not implement business logic in JAX-RS resources; delegate instead
- put transaction boundaries on the project's service/application/use-case methods according to the existing convention; when the transaction is intentionally tied to a request or entry point, place it on the resource or entry-point method instead
- avoid calling repositories or persistence directly from resources except for trivial generated code explicitly requested by the user

## Application Logic
- implement procedural business logic and application use cases in the project's existing service/application/use-case location
- use CDI scopes such as `@ApplicationScoped`, `@RequestScoped`, `@Dependent`, or the project's custom stereotypes for injectable components
- keep application methods independent of HTTP, servlet, resource, and JSON serialization details
- let application methods express use cases in domain terms rather than transport terms
- prefer constructor injection when the project style allows it; field injection is acceptable when the project or framework conventions require it
- avoid leaking MicroProfile or Jakarta EE framework concerns into domain code unless the project already follows an active-record or framework-centric model

## Domain And Data Model
- maintain domain objects, data classes, JPA entities, value objects, enums, and domain behavior in the project's existing model/domain/entity location
- entities maintain state and corresponding behavior
- model stable value objects as records or enums when appropriate
- direct references across independent modules, features, or components are allowed when they fit the existing architecture, but aim for maximal cohesion and minimal coupling
- if a relation exists in the database, the entity model must carry a corresponding reference, id field, or association; the DB schema is the source of truth when it already exists
- excessive cross-module references or shared configuration are refactoring signals; split, merge, or rebalance responsibilities to restore cohesion

## Repositories And Persistence
- place repositories, entity managers, data sources, and persistence integration near the aggregate, feature, service, or persistence package that owns the persistent concept according to the existing architecture
- use JPA, Jakarta Data, or the project's chosen persistence technology consistently
- do not expose JPA or persistence-specific types directly in JAX-RS resources unless the existing API contract already exposes them
- prefer explicit query methods or small custom queries over broad generic repository use in business logic

## Exceptions And HTTP Errors
- represent domain failures with domain/application exceptions, not HTTP-specific exceptions in application or domain code
- map exceptions to HTTP status codes using JAX-RS `ExceptionMapper` or by throwing JAX-RS `WebApplicationException` subclasses
- use explicit exceptions such as `BadRequestException`, `NotFoundException`, `ForbiddenException`, etc. for the matching HTTP status; prefer these over constructing `Response` objects inline
- for custom exceptions, inherit from `WebApplicationException` when they are intentionally HTTP-facing
- keep exception mapping centralized through `ExceptionMapper` providers for reusable APIs

## JSON Serialization
- use JSON-P as the default JSON mechanism in MicroProfile applications; prefer JSON-P over JSON-B unless the project already uses JSON-B or JSON-B is a better fit
- map JSON at the web/API edge to request/response DTOs or command/query objects; do not bind external API shapes directly to rich domain entities unless the API is intentionally internal
- when using JSON-P, record entities should ship with a `toJSON()` method returning `JsonObject` and a static `fromJSON(JsonObject)` factory
- keep JSON-P mapping in the boundary/web layer; convert to/from domain objects in the boundary or application layer
- use JSON-B or custom mapping only when the project already uses it or the MicroProfile implementation favors it

## Validation
- use Jakarta Bean Validation on request DTOs for syntactic request validation
- place business validation in application/domain code so it remains independent of HTTP and can be tested without JAX-RS
- use `@Valid` at resource method parameters when consuming validated request bodies or parameters
- do not use validation annotations as the only enforcement for domain invariants that must hold outside HTTP requests

## Configuration
- use MicroProfile Config (`@ConfigProperty` or `ConfigProvider`) consistently with the existing project
- prefer typed configuration interfaces or CDI beans over scattered `@ConfigProperty` fields when more than one related property is used
- keep environment-specific values in environment variables, profiles, or deployment configuration, not hardcoded in source
- do not introduce new config namespaces, property files, or profiles without checking existing conventions first
- avoid reading configuration directly from deep domain code; inject typed configuration into CDI-managed components or adapters that need it

## Observability
- use MicroProfile Health for health checks, MicroProfile Metrics for application metrics, and OpenTelemetry / MicroProfile Telemetry for tracing when available
- create custom health checks near the component, feature, adapter, or integration whose health they expose
- create metrics with MicroProfile Metrics or an OpenTelemetry-compatible naming scheme
- avoid high-cardinality metric tags such as user ids, request ids, emails, or raw URLs
- log at application edges for incoming/outgoing integration events and in application services for meaningful business milestones; do not log sensitive data

## Security
- use MicroProfile JWT Auth, Jakarta Security, or the project's existing security mechanism when authentication or authorization is needed
- keep authorization decisions close to resources, handlers, or application use cases; do not scatter role checks through domain entities
- prefer declarative security (`@RolesAllowed`, `@PermitAll`, `@DenyAll`) on JAX-RS resources when it improves readability and testability
- do not disable authentication, authorization, CORS, or security globally unless the project context explicitly requires it and the user agrees
- never add secrets, tokens, passwords, or private keys to source files or test fixtures

## Testing
- write unit tests for application/domain behavior without starting the CDI container when possible
- write JAX-RS slice tests with the project's test tooling (e.g. `@ExtendWith(WeldJunit5AutoExtension.class)`, Arquillian, or implementation-specific test frameworks) when verifying resource behavior
- write persistence slice tests when verifying repository/query behavior
- write integration tests only when the CDI container, configuration, wiring, or end-to-end behavior is the subject under test
- do not overuse mocks; prefer smaller unit tests or focused slices when possible
- integration tests should follow the project's naming convention; when there is no convention, use `*IT` for integration tests and keep unit tests as `*Test`
- execute relevant tests after every meaningful change unless the user explicitly activates demo/showtime mode

## System Tests
- create system tests as a separate Maven module ending with `-st` when the project already has that convention or when the service is tested as a deployed process
- use MicroProfile REST Client interfaces for testing JAX-RS resources
- REST client interfaces live in `src/main/java` of the `-st` module; test classes live in `src/test/java` of the `-st` module
- name client interfaces after the resource with a `Client` suffix (e.g. `GreetingsResource` -> `GreetingsResourceClient`)
- use `@RegisterRestClient(configKey = "service_uri")`
- system tests end with `IT` suffix
- do not use RestAssured unless the project already standardizes on it; prefer MicroProfile REST Client or JDK `HttpClient`
- do not create new `@RegisterRestClient(configKey, ...)` declarations; reuse the existing client configuration pattern
- execute system tests after major service changes when feasible

## JavaDoc And Examples
- follow links in JavaDoc to external specifications (MicroProfile, Jakarta EE, Java SE) and use them for code generation
- use popular technical terms from the Java SE, MicroProfile, and Jakarta EE ecosystems as examples in unit tests and JavaDoc

## README Guidelines
- write brief, to-the-point README.md files for advanced developers
- use precise and concise language; avoid generic adjectives like "simple" or "lightweight"
- do not include detailed project structure file/folder listings; high-level module descriptions are acceptable
- do not list every REST endpoint in READMEs; link to OpenAPI/API docs when present
- if modules are listed, provide links
- do not use the term "Orchestrates"; use more specific alternatives

## Project Management
- on opening existing projects, load `AGENTS.md` if present before making changes
- do not create or change files on opening existing projects; stop after initialization and wait for instructions when the user only asked to inspect or initialize
- do not generate code initially in an empty project unless the user explicitly asks to scaffold or implement something
- always inspect existing package, test, build, and dependency conventions before adding code
- keep changes minimal and aligned with the project's current MicroProfile / Jakarta EE versions
- do not migrate between MicroProfile or Jakarta EE major versions unless the user explicitly requests a migration
- always ask before changing `pom.xml`

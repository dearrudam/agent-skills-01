---
name: spring-boot-server
description: Stack-specific coding rules for long-running Java Spring Boot server applications, covering Spring MVC REST controllers, dependency injection, Jackson JSON, validation, configuration, persistence integration, testing (unit/integration/system), observability, security, and Maven/Gradle project conventions. Use whenever creating, generating, scaffolding, writing, migrating, troubleshooting, or reviewing Spring Boot server code. This skill is architecture-neutral, it can be composed it with BCE, package-by-feature, package-by-layer, SDD4J, or another architecture skill when the project or user specifies an architecture. Not for serverless deployments, one-off Java CLI applications, or non-Spring Jakarta/MicroProfile services.
---

## Composition
- compose with `java-conventions` for all language-level Java rules (syntax, style, naming, visibility, interfaces/classes, methods/lambdas, streams/collections, exceptions, comments/JavaDoc)
- compose with an architecture skill when architecture is specified or already present, such as `bce`, `sdd4j-bce`, `sdd4j-package-by-feature`, or `sdd4j-package-by-layer`
- when no architecture is specified, infer and preserve the existing project organization instead of introducing BCE, package-by-feature, or package-by-layer by default
- this skill specializes only the Spring Boot server stack and does not restate language-level Java or architecture-level rules

## Dependencies
- prefer dependencies in this order: Java SE, Spring Boot starters already present in the project, Spring ecosystem modules already used by the project
- avoid adding dependencies for problems already solved by Spring Boot, Java SE, or the existing project stack
- ask before changing Maven `pom.xml`, Gradle build files, dependency versions, Java version, Spring Boot version, or plugin configuration
- do not introduce a second web stack; Spring MVC and WebFlux should not be mixed unless the existing project already does so deliberately

## Architecture Fit
- treat Spring Boot as the application stack, not as the architecture
- preserve the architecture already used by the project, including package-by-feature, package-by-layer, BCE, hexagonal, clean architecture, modular monolith, or a local project convention
- do not rename packages, introduce architectural layers, or reorganize code solely because this skill is active
- when adding new code, place it where equivalent Spring components already live
- when no convention exists, choose the smallest clear structure for the requested change and avoid committing the project to a broad architecture prematurely
- keep Spring framework annotations at application entry points, application services, configuration, adapters, and persistence integration points; avoid leaking Spring concerns into domain code unless the project already follows an active-record or Spring-centric model

## Web/API Entry Points
- place Spring MVC controllers, REST API DTO mapping, request/response models, scheduled entry points, messaging listeners, external API clients, health indicators, and protocol adapters according to the existing architecture
- name REST controllers in plural after the resource they expose, e.g. `SpeakersController` rather than `SpeakerController`
- keep controllers coarse-grained and free of business logic; validate and translate HTTP input, then delegate to application services, handlers, or use cases
- use `@RestController` for JSON HTTP APIs and `@Controller` only when rendering views or redirects is intentional
- declare request mappings at class level where it clarifies the resource path
- return `ResponseEntity<T>` when status, headers, or empty responses matter; return DTOs directly only for straightforward successful responses
- put `@Transactional` on request-sized use case methods when the transaction boundary is intentionally tied to that entry point
- avoid calling repositories directly from controllers except for trivial generated code explicitly requested by the user

## Application Logic
- implement procedural business logic and application use cases in the project's existing service/application/use-case location
- use Spring stereotypes such as `@Service` or `@Component` for injectable application classes
- keep application services independent of HTTP, servlet, controller, and JSON serialization details
- let application methods express use cases in domain terms rather than transport terms
- place `@Transactional` on application service/use-case methods when the transaction is intentionally scoped to reusable application logic
- prefer constructor injection; avoid field injection

## Domain And Data Model
- maintain domain objects, data classes, JPA entities, value objects, enums, and domain behavior in the project's existing model/domain/entity location
- entities maintain state and corresponding behavior
- model stable value objects as records or enums when appropriate
- direct references across independent modules, features, or components are allowed when they fit the existing architecture, but aim for maximal cohesion and minimal coupling
- if a relation exists in the database, the entity model must carry a corresponding reference, id field, or association; the DB schema is the source of truth when it already exists
- excessive cross-module references or shared configuration are refactoring signals; split, merge, or rebalance responsibilities to restore cohesion
- keep JPA annotations out of DTOs and controller request/response types

## Repositories And Persistence
- place Spring Data repositories near the aggregate, feature, service, or persistence package that owns the persistent concept according to the existing architecture
- repositories may live in application, domain, persistence, infrastructure, adapter, feature, or entity packages depending on the project convention; follow that convention consistently
- do not expose Spring Data repositories directly as REST resources unless the project already uses Spring Data REST and the user explicitly wants that style
- avoid leaking `Pageable`, `Page`, `Specification`, or persistence-specific types outside Spring-facing API/application code unless the existing API contract already exposes them
- prefer explicit query methods or small custom queries over broad generic repository use in business logic

## Exceptions And HTTP Errors
- represent domain failures with domain/application exceptions, not HTTP-specific exceptions in application or domain code
- map exceptions to HTTP status codes in the web/API layer with `@ControllerAdvice` and `@ExceptionHandler`
- use `ResponseStatusException` only for small web/API-local cases; prefer centralized exception mapping for reusable APIs
- for Spring Boot 3+, prefer `ProblemDetail` for structured API errors when the project already uses Spring Framework 6 error conventions or when adding a new API error format
- never construct successful and error response payloads ad hoc across multiple controllers when a shared error format exists

## JSON Serialization
- use Jackson as the default JSON mechanism in Spring Boot applications
- map JSON at the web/API edge to request/response DTOs or command/query objects; do not bind external API shapes directly to rich domain entities unless the API is intentionally internal
- prefer records for immutable request/response DTOs when validation, serialization, and project style allow it
- keep Jackson annotations at the DTO/API model level when possible; avoid polluting domain entities with transport-specific JSON annotations unless persistence/API compatibility requires it
- use `@JsonFormat`, `@JsonProperty`, and custom serializers sparingly and only when the API contract requires them

## Validation
- use Bean Validation on request DTOs for syntactic request validation
- place business validation in application/domain code so it remains independent of HTTP and can be tested without Spring MVC
- use `@Valid` or `@Validated` at controller entry points when consuming validated request bodies or parameters
- do not use validation annotations as the only enforcement for domain invariants that must hold outside HTTP requests

## Configuration
- use `application.yml` or `application.properties` consistently with the existing project
- prefer typed `@ConfigurationProperties` over scattered `@Value` fields when more than one related property is used
- keep environment-specific values in profiles, environment variables, or deployment configuration, not hardcoded in source
- do not introduce new profiles, property namespaces, or configuration files without checking existing conventions first
- avoid reading configuration directly from deep domain code; inject typed configuration into Spring-managed components or adapters that need it

## Observability
- use Spring Boot Actuator for health, info, metrics, and readiness/liveness endpoints when observability is needed
- create custom health indicators near the component, feature, adapter, or integration whose health they expose
- create metrics with Micrometer and prefer OpenTelemetry-compatible naming and labels
- avoid high-cardinality metric tags such as user ids, request ids, emails, or raw URLs
- log at application edges for incoming/outgoing integration events and in application services for meaningful business milestones; do not log sensitive data

## Security
- use Spring Security when authentication or authorization is needed
- keep authorization decisions close to controllers, handlers, or application use cases; do not scatter role checks through domain entities
- prefer method security for use-case authorization when it improves readability and testability
- do not disable CSRF, CORS, authentication, or authorization globally unless the project context explicitly requires it and the user agrees
- never add secrets, tokens, passwords, or private keys to source files or test fixtures

## Testing
- write unit tests for application/domain behavior without starting the Spring context when possible
- write Spring MVC slice tests with `@WebMvcTest` for controller behavior and HTTP mapping
- write persistence slice tests with `@DataJpaTest` when verifying repository/query behavior
- write integration tests with `@SpringBootTest` only when the Spring container, configuration, wiring, or end-to-end behavior is the subject under test
- use Testcontainers when external infrastructure is needed and the project already uses it or the user approves adding it
- do not overuse `@MockBean`/`@MockitoBean`; prefer smaller unit tests or focused slices when possible
- integration tests should follow the project's naming convention; when there is no convention, use `*IT` for integration tests and keep unit tests as `*Test`
- execute relevant tests after every meaningful change unless the user explicitly activates demo/showtime mode

## System Tests
- create system tests as a separate module or clearly separated test source set when the project already has that convention or when the service is tested as a deployed process
- prefer HTTP clients already used by the project; otherwise use Spring `WebTestClient`, `RestClient`, or JDK `HttpClient` depending on the test boundary
- system tests should exercise the running service through public interfaces, not through Spring internals
- avoid RestAssured unless the project already standardizes on it
- execute system tests after major service changes when feasible

## README Guidelines
- write brief, to-the-point README.md files for advanced developers
- use precise and concise language; avoid generic adjectives like "simple" or "lightweight"
- do not include detailed project structure file/folder listings; high-level module descriptions are acceptable
- do not list every REST endpoint in READMEs; link to API docs when present
- if modules are listed, provide links
- do not use the term "Orchestrates"; use more specific alternatives

## Project Management
- on opening existing projects, load `AGENTS.md` if present before making changes
- do not create or change files on opening existing projects; stop after initialization and wait for instructions when the user only asked to inspect or initialize
- do not generate code initially in an empty project unless the user explicitly asks to scaffold or implement something
- always inspect existing package, test, build, and dependency conventions before adding code
- keep changes minimal and aligned with the project's current Spring Boot major version
- do not migrate between Spring Boot major versions unless the user explicitly requests a migration

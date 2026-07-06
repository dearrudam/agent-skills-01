---
name: sdd4j-package-by-feature
description: SDD4J architecture adapter for Java projects organized by feature or capability package. Use with SDD4J and Java stack skills when each feature owns a package containing its spec, entrypoints, application code, domain/model code, and tests. Trigger on sdd4j-package-by-feature, package-by-feature, feature package, vertical slice package, capability package, or Java architecture mapping for co-located specs.
metadata:
  type: architecture-adapter
---

# Skill: Package By Feature

## Objective

Map a Java capability to one feature-owned package. This skill owns architecture layout only. Compose it with `sdd4j` for spec workflow and with a stack skill for framework idioms and verification.

## Default Layout

Use this shape unless the project's `AGENTS.md` declares a different mapping:

```text
src/main/java/<base>/<capability>/
  package-info.java
  <Capability>Controller.java       # optional, stack-specific entrypoint
  <Capability>Service.java          # optional, application operation owner
  <DomainType>.java                 # domain/model/entity types
  web/                              # optional
  application/                      # optional
  domain/                           # optional
  persistence/                      # optional

src/test/java/<base>/<capability>/
  <Capability>Test.java
```

The capability package is the architecture unit. Prefer co-locating related code under that package instead of spreading classes across global `controller`, `service`, `repository`, or `model` packages.

## SDD4J Mapping

When composed with SDD4J:

- An SDD4J capability maps to one Java feature package.
- The spec lives at the feature package's `package-info.java`.
- The capability name maps to the final package segment unless `AGENTS.md` declares another pattern.
- `## Boundary` operations map to public entrypoints or application operations inside the feature package.
- `## Entities` entries map to domain, model, aggregate, value object, or persistence entity classes inside the feature package or its subpackages.
- Internal helpers, configuration classes, mappers, repositories, adapters, and persistence details are implementation unless the spec explicitly declares them as contract-relevant entities or operations.
- Requirement ids must be visible in tests under the mirrored test package or the stack's test location.

## Operation Mapping

Map each transport-neutral operation to the narrowest stable code entrypoint:

- For HTTP applications, prefer the application method behind the controller when that method is stable and testable.
- If the controller method is the only stable boundary, map the operation to the controller method.
- For event-driven code, map to the listener or handler method that receives the event.
- For CLI code, map to the command or use-case method.

Do not force every operation to have both controller and service methods. The stack skill decides idiomatic structure.

## Drift Detection

Detect spec-to-code gaps:

- A `## Boundary` operation has no mapped entrypoint or application operation in the feature package.
- A `## Entities` item has no matching domain/model/entity type when the architecture mapping says it should be materialized.
- A requirement id has no grep-visible test trace.

Detect code-to-spec drift:

- A public entrypoint or application operation in the feature package is not represented in `## Boundary`.
- A domain/model/entity type appears contract-relevant but is absent from `## Entities`.
- A test under the feature package references a requirement id not present in the spec.

Surface drift to the user. Do not rewrite the spec to match code without explicit instruction.

## AGENTS.md Override

Use this compact project mapping when defaults do not fit:

```md
## SDD4J

Architecture layout:
- skill: `sdd4j-package-by-feature`
- source root: `src/main/java`
- base package: `com.acme`
- capability package pattern: `com.acme.<capability>`
- test package mirrors main package: true
- entrypoint packages: same package, `web`, `application`
- entity packages: same package, `domain`, `model`, `persistence`
```

If the project has feature packages plus a few shared packages, treat shared packages as cross-cutting implementation unless the SDD4J system doc or `AGENTS.md` declares them part of a capability contract.

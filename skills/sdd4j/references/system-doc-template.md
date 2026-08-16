# System doc template (base package)

The system doc is the **optional** spec one altitude above the SDD4J capability specs. It lives in the base
package's doc — there is no separate `specs/` tree:

- **Java**: `src/main/java/<base>/package-info.java` — each line prefixed `///` ([JEP 467](https://openjdk.org/jeps/467) Markdown doc comments), ending with the `package <base>;` declaration.

Each SDD4J capability's own `package-info` answers *what that one boundary promises*. The system doc answers only the questions that **span** SDD4J capabilities and have nowhere else to live. Add a section only when a real cross-SDD4J capabilities concern appears — a one-SDD4J capability system needs no system doc.

Rules for filling it in:

- **Cross-SDD4J capability only.** Anything that belongs to a single boundary stays in that SDD4J capability's spec.
- **Never duplicate a SDD4J capability's one-liner.** A hand-maintained SDD4J capability index drifts and breaks the single-source-of-truth rule — *the gap is read, not stored*. If you want a SDD4J capability map, mark it **generated** and regenerate it from the per-SDD4J capability docs; never hand-type it.
- **Composition is concrete wiring**, not generic rules — `/bce` owns BCE layering and naming bans; the system doc owns *this system's* allowed dependencies and integration events.
- **Vision is the one exception.** Optional, one aspirational sentence — the outcome the assembly chases, distinct from the Charter's mandate ("what this assembly is"). Pure rationale: it carries **no `Sn`**, traces to **no test**, and is the single non-verifiable line in the doc. May be proposed by `/sdd4j new` distilling a README seed (the human accepts or edits). Omit it unless a real aspiration exists.
- **System invariants** are EARS `shall` statements (the system is the assembly, not one SDD4J capability). Same six patterns as a SDD4J capability spec, and the same traceability: each carries a stable id `Sn` that resolves to the exact runner-visible identity of at least one executable test or case, and every literal or symbolic test trace must resolve to an existing system invariant.
- **Ubiquitous language** defines shared nouns once, so each SDD4J capability's `## Entities` stays terse — names plus a one-line meaning, no fields, no types.
- **Decisions are append-only rationale.** Optional. Each confirmed choice carries a stable id `Dn`, states the decision, and names the rejected alternatives in a trailing `_(why: …; rejected: …)_`. Like Vision: no test, not a trace target. Immutable — a reversed decision gets a new entry and the old one is marked `superseded by Dm`, never edited or deleted. Testable behaviour belongs in an EARS statement instead; a standing project rule in the README's `## Conventions`.
- It is not a tasks file and not a gap registry.

The Markdown body (this is the whole system doc — every section optional except the charter):

```markdown
# <System Name>
> One sentence: what the whole assembly of SDD4J capabilities promises.

## Vision
<!-- optional; the aspirational outcome the assembly chases; rationale, not contract; no Sn, no test -->
- Make checkout so fast the customer never abandons a cart.

## Components
<!-- this system's concrete wiring — direction matters; each SDD4J capability's own contract lives in its package-info -->
- `checkout` may call `inventory`; never the reverse.
- `payment` is reached only via `checkout`'s `place-order`.

## System invariants
<!-- cross-cutting EARS `shall` statements no single SDD4J capability owns; the system is the assembly; each carries a stable id Sn that >=1 test embeds -->
- S1 — The system shall never expose an unconfirmed order outside `checkout`.

## Ubiquitous language
<!-- shared domain nouns, defined once; names + one-line meaning, no fields, no types -->
- Order — a confirmed, cancellable intent to buy. Owned by `checkout`.
- Cart — a mutable pre-order collection of items.

## Decisions
<!-- optional; append-only confirmed choices with rejected alternatives; rationale, not contract — no test; supersede, never edit -->
- D1 — Routing uses the Navigation API. _(why: web-platform first; rejected: router libraries)_
- D2 — `payment` is its own SDD4J capability, not a `checkout` control. _(why: independent provider swap; rejected: folding into `checkout`)_

## Stack
<!-- the composed stack skill + package base, so `apply` reads it instead of re-inferring -->
- spring-boot-server · base package `werneck`
```

In **Java**, prefix every line with `///` and end the file with the base package declaration:

```java
/// # Werneck Store
/// > Turn a browsing customer into a fulfilled, paid order.
///
/// ## Vision
/// - Make checkout so fast the customer never abandons a cart.
///
/// ## Components
/// - `checkout` may call `inventory`; never the reverse.
/// …
package werneck;
```

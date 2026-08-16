# Capability spec template

Use this template when authoring a capability contract in `package-info.java`. Write the prose in the `Spec language` resolved from `AGENTS.md ## SDD4J`, while keeping structural section names, requirement ids, operation ids, and code identifiers stable unless the project explicitly declares otherwise.

The Markdown body:

```markdown
# Capability Title
> One sentence responsibility.

## Boundary
<!-- the single external entry point — operations as verb-noun, transport-neutral -->
- `place-order` — submit a cart for fulfilment
- `cancel-order` — withdraw an unfulfilled order

## Requirements
<!-- EARS statements (the system is the capability); group related ones under a titled Rn; give each statement a stable id Rn.m; every boundary op traces to a group; every statement id traces to >=1 test that embeds it -->
### R1: Place an order
- R1.1 — When a cart with at least one item is submitted, the BC shall create and confirm an order.
- R1.2 — If the cart is empty, then the BC shall reject the request. _(why: empty carts were the top source of phantom orders)_

### R2: Cancel an order
- R2.1 — While an order is unfulfilled, the BC shall allow it to be cancelled.
- R2.2 — If the order is already fulfilled, then the BC shall reject the cancellation.

## Entities
<!-- optional — stateful domain nouns this BC owns; names only, no fields, no types; omit the whole section if none -->
- Order
- Cart

## Out of scope
<!-- what this BC deliberately does not do; keep the heading even when empty, to keep the boundary sharp -->
```

In Java, prefix every Markdown line with `///` when the project supports JEP 467 Markdown documentation comments, then end the file with the package declaration. Otherwise, use a conventional Javadoc comment followed by the package declaration.

```java
/// # Ordering
/// > Accept a cart and turn it into a confirmed, cancellable order.
///
/// ## Boundary
/// - `place-order` — submit a cart for fulfilment
/// …
package com.acme.ordering;
```

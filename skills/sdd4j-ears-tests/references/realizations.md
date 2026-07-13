# Per-stack Realizations

The mapping is fixed: group `Rn` becomes one parameterized, table-driven, or grouped test skeleton; statement `Rn.m` becomes one labeled row or case. Only the concrete syntax changes per stack. Pick the idiom the project already uses.

Example SDD4J requirement group:

```md
### R1 Place an order

- R1.1 - When a cart with at least one item is submitted, the capability shall create and confirm an order.

- R1.2 - If the cart is empty, then the capability shall reject the request.

```

In every realization, `R1.1` and `R1.2` are grep-visible trace tokens. Fixture values and assertions are authored. Do not fabricate domain values merely to make a test pass.

## JUnit 5

Use one parameterized test per group when multiple statements share the same operation skeleton.

```java
@ParameterizedTest(name = "{0}")
@MethodSource("placeOrderCases")
void placeOrder(String requirement, Cart cart, boolean shouldConfirm) {
    var outcome = checkout.placeOrder(cart);
    assertEquals(shouldConfirm, outcome.isConfirmed(), requirement);
}

static Stream<Arguments> placeOrderCases() {
    return Stream.of(
        arguments("R1.1", Cart.of(item("duke-sticker")), true),
        arguments("R1.2", Cart.empty(), false)
    );
}
```

If values or assertions are unknown, keep the id and emit a stack-idiomatic failing TODO rather than guessing.

## JUnit 5 Plain Test

For a single-statement group, a plain test is fine when the id remains visible.

```java
@Test
@DisplayName("R2.1 rejects expired carts")
void r2_1_rejectsExpiredCarts() {
    fail("TODO R2.1: define expired cart fixture and rejection assertion");
}
```

## zunit Or Zero-dependency Java Tests

Use a case record/list and include the requirement id in assertion messages.

```java
void main() {
    record Case(String requirement, Cart cart, boolean shouldConfirm) {}

    var cases = List.of(
        new Case("R1.1", Cart.of(item("duke-sticker")), true),
        new Case("R1.2", Cart.empty(), false)
    );

    for (var c : cases) {
        var outcome = Checkout.placeOrder(c.cart());
        if (outcome.confirmed() != c.shouldConfirm()) {
            throw new AssertionError("%s expected confirmed=%s but was %s"
                .formatted(c.requirement(), c.shouldConfirm(), outcome.confirmed()));
        }
    }
}
```

## Cross-capability System Tests

When a stack uses system tests that cross capability boundaries, keep ids explicit and avoid hiding multiple capability ids behind one vague test name.

```java
@Test
@DisplayName("R1.1 checkout creates order and R3.2 notification is queued")
void checkoutCreatesOrderAndQueuesNotification() {
    fail("TODO R1.1 R3.2: define cross-capability assertion");
}
```

Use cross-capability traces only when SDD4J system docs or project mapping declare that style. Otherwise, keep tests under the owning capability.

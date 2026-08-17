# Per-stack Realizations

The mapping is fixed: group `Rn` becomes one parameterized, table-driven, or grouped test skeleton; statement `Rn.m` becomes one labeled row or case. Only the concrete syntax changes per stack. Pick the idiom the project already uses — never add a second.

All examples realize the canonical SDD4J `checkout` group, whose two statements share the
`place-order` boundary op and deliberately mix a happy and an unhappy row:

```md
### R1 Place an order

- R1.1 - When a cart with at least one item is submitted, the capability shall create and confirm an order.

- R1.2 - If the cart is empty, then the capability shall reject the request.

```


In every realization the **`R1.1` / `R1.2` id is the runner-visible trace token** (a case label), keeping trace coverage complete in both directions without orphan ids. The `<response>` assertion and the fixture stay **authored** — emit them as a failing stub, never a fabricated value, so an unwritten check shows red.


## Java trace symbols — the generated `{BC name in CamelCase}Requirement` annotation

Java stacks (`microprofile-server`, `java-cli-app`, `spring-boot-server`) materialize the trace tokens as **symbols**: one
generated file per BC, `{BC name in CamelCase}Requirement.java` in the BC root package (beside `boundary/`, `control/`,
`entity/`) — a `@Documented` annotation with a nested `Rn` enum, one constant per statement, the
EARS sentence as its doc, `toString()` returning the literal spec id. In the example below, the `@Documented` annotation is for the `orders` BC: 

```java
package orders;

import java.lang.annotation.*;

/// Generated from the capability spec in [orders] — do not edit.
/// Marks the boundary method or test that realizes the given requirement statements.
@Documented
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface OrdersRequirement {

    /// One constant per statement id in the spec's `## Requirements`.
    enum Rn {
        /// When a cart with at least one item is submitted, the BC shall create and confirm an order.
        R1_1("R1.1", "When a cart with at least one item is submitted, the BC shall create and confirm an order."),
        /// If the cart is empty, then the BC shall reject the request.
        R1_2("R1.2", "If the cart is empty, then the BC shall reject the request.");

        private final String id;
        private final String statement;
        Rn(String id, String statement) { this.id = id; this.statement = statement; }
        public String statement() { return statement; }
        @Override public String toString() { return id; }
    }

    Rn[] value();
}
```

- **The spec stays the single authored source.** The `## Requirements` section of the BC's
  `package-info.java` owns the statements; `/sdd4j apply` regenerates `{BC name in CamelCase}Requirement.java` wholesale on
  every pass. Never hand-edit it — regeneration is the drift oracle. BC name in camelcase is used to avoid the necessity to
  import by FQN classes in any classes that import more than one BC requirement annotation classes.
- **Public, own file, per BC.** The BC spans layer subpackages, so the type must be `public`; a
  package-private type (e.g. one declared inside `package-info.java`) is invisible to
  `orders.boundary`. An annotation element must be typed to one concrete enum, so the annotation
  cannot be shared across BCs — each BC generates its own, and deleting the BC deletes its trace
  apparatus with it.
- **Usage.** `Rn` constants in parameterized rows (the per-statement trace); `@{BC name in CamelCase}Requirement(R1_2)` on
  a plain single-statement test; `@{BC name in CamelCase}Requirement({R1_1, R1_2})` on the boundary method that realizes
  the group. Never a statement list on a parameterized test method — it duplicates the rows and drifts.
- **Retirement is fail-closed.** A statement removed from the spec drops its constant on
  regeneration, and every row still referencing it becomes a compile error. The reverse direction —
  a new statement with no covering row — is an unused constant and compiles; that check stays with
  `/sdd4j`'s bidirectional trace coverage pass.
- **The EARS sentence is emitted twice, on purpose.** As the `///` doc (IDE hover, javadoc constant
  summary) and as the `statement()` field (runtime access — failure messages print the violated
  requirement verbatim, `Rn.values()` is the requirements table via reflection). Both come from the
  one authored source on every regeneration, so the in-file duplication cannot drift. `toString()`
  stays the bare id — the runner label and grep depend on it; the sentence rides on `statement()` only.
- **Javadoc.** `@Documented` publishes `@{BC name in CamelCase}Requirement({R1_1, R1_2})` on each boundary method's
  signature, hyperlinked to the enum page, whose constant summary doubles as the requirements table;
  the package spec links it with `[{BC name in CamelCase}Requirement.Rn]`. Spec → vocabulary → realizing methods, all
  navigable in the generated site.
- **Scope ends at the unit/integration line.** The `-st` module is black box (no code dependency on
  the server) and keeps literal string labels, like the web stacks.

## JUnit 5

One `@ParameterizedTest` per group; one `@MethodSource` row per statement; the row's `Rn` constant is
the case `name` — `toString()` prints the spec id, so the runner shows `R1.1` and find-usages on the
constant lists every covering row. In the example below, it's importing the BC requirement annotation for the `orders` BC:

```java
import static orders.OrdersRequirement.Rn.*;

@ParameterizedTest(name = "{0}")
@MethodSource("placeOrderCases")
void placeOrder(OrdersRequirement.Rn requirement, Cart cart, boolean shouldConfirm) {
    var outcome = checkout.placeOrder(cart);            // shared act — the group's boundary op
    // authored per row — TODO until /sbce apply fills the assertion:
    assertEquals(shouldConfirm, outcome.isConfirmed(),
        requirement + " — " + requirement.statement());
}

static Stream<Arguments> placeOrderCases() {
    return Stream.of(
        arguments(R1_1, Cart.of(item("duke-sticker")), true),   // When item present → confirm
        arguments(R1_2, Cart.empty(),                  false)    // If empty → reject
    );
}
```

A statement removed from the spec removes its constant, and the stale `arguments(...)` row fails to
compile — retirement is enforced by the compiler, not by grep. For a single-statement group, a plain
`@Test` annotated `@{BC name in CamelCase}Requirement(R1_2)` is fine.

## zunit Or Zero-dependency Java Tests

Use a case record/list and include the requirement id in assertion messages. In the example below, it's importing the BC
requirement annotation for the `orders` BC:

```java
import static orders.OrdersRequirement.Rn.*;

void main() {
    record Case(OrdersRequirement.Rn req, Cart cart, boolean shouldConfirm) {}
    var cases = List.of(
            new Case(R1_1, Cart.of(item("duke-sticker")), true),   // When item present → confirm
            new Case(R1_2, Cart.empty(),                  false)    // If empty → reject
    );
    for (var c : cases) {
        var outcome = Checkout.placeOrder(c.cart());             // shared act
        assert outcome.confirmed() == c.shouldConfirm()          // authored per row
                : "%s — %s — expected confirmed=%s but was %s"
                .formatted(c.req(), c.req().statement(), c.shouldConfirm(), outcome.confirmed());
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

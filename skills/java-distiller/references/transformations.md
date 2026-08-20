# Java Distiller Transformation Catalog

Reference catalog of before/after patterns for the `java-distiller` skill.

## 1. Syntax Modernization

### 1.1 `var` for local variables

Use `var` when the type is obvious from the right-hand side.

**Before:**
```java
List<String> names = new ArrayList<>();
HttpClient client = HttpClient.newHttpClient();
```

**After:**
```java
var names = new ArrayList<String>();
var client = HttpClient.newHttpClient();
```

### 1.2 Text blocks

Use text blocks for multi-line strings.

**Before:**
```java
String json = "{\n" +
              "  \"name\": \"test\"\n" +
              "}\n";
```

**After:**
```java
String json = """
    {
      "name": "test"
    }
    """;
```

### 1.3 Switch expressions

Replace verbose switch statements with expressions.

**Before:**
```java
int status;
switch (state) {
    case NEW:
        status = 1;
        break;
    case ACTIVE:
        status = 2;
        break;
    default:
        status = 0;
}
```

**After:**
```java
var status = switch (state) {
    case NEW -> 1;
    case ACTIVE -> 2;
    default -> 0;
};
```

### 1.4 Pattern matching for `instanceof`

Use pattern matching to avoid casts.

**Before:**
```java
if (obj instanceof String) {
    String s = (String) obj;
    return s.length();
}
```

**After:**
```java
if (obj instanceof String s) {
    return s.length();
}
```

### 1.5 Module imports

Use module imports to reduce import lists.

**Before:**
```java
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
```

**After:**
```java
import module java.net.http;
```

Use only when the target JDK supports module imports.

## 2. API Upgrades

### 2.1 `java.time` over `Date`/`Calendar`

**Before:**
```java
Date now = new Date();
Calendar cal = Calendar.getInstance();
```

**After:**
```java
Instant now = Instant.now();
ZonedDateTime nowInZone = ZonedDateTime.now(ZoneId.of("UTC"));
```

### 2.2 `java.nio.file` over `java.io.File`

**Before:**
```java
File file = new File("data.txt");
if (file.exists()) {
    // ...
}
```

**After:**
```java
var path = Path.of("data.txt");
if (Files.exists(path)) {
    // ...
}
```

### 2.3 `HttpClient` over `HttpURLConnection`

**Before:**
```java
URL url = new URL("https://example.com");
HttpURLConnection conn = (HttpURLConnection) url.openConnection();
conn.setRequestMethod("GET");
```

**After:**
```java
var request = HttpRequest.newBuilder()
    .uri(URI.create("https://example.com"))
    .build();
var client = HttpClient.newHttpClient();
```

### 2.4 Factory methods for collections

**Before:**
```java
List<String> list = Arrays.asList("a", "b", "c");
Map<String, Integer> map = new HashMap<>();
map.put("a", 1);
map.put("b", 2);
```

**After:**
```java
var list = List.of("a", "b", "c");
var map = Map.of("a", 1, "b", 2);
```

### 2.5 `Optional` over null checks

**Before:**
```java
String value = findValue();
if (value != null) {
    return value.toUpperCase();
}
return null;
```

**After:**
```java
return Optional.ofNullable(findValue())
    .map(String::toUpperCase)
    .orElse(null);
```

## 3. Pattern Adoption

### 3.1 Records for data carriers

**Before:**
```java
public class Point {
    private final int x;
    private final int y;

    public Point(int x, int y) { this.x = x; this.y = y; }

    public int getX() { return x; }
    public int getY() { return y; }

    // equals, hashCode, toString omitted
}
```

**After:**
```java
public record Point(int x, int y) {}
```

### 3.2 Sealed interfaces for closed hierarchies

**Before:**
```java
public interface Shape {}
public class Circle implements Shape {}
public class Square implements Shape {}
```

**After:**
```java
public sealed interface Shape permits Circle, Square {}
public record Circle(double radius) implements Shape {}
public record Square(double side) implements Shape {}
```

## 4. Functional Style

### 4.1 Streams over imperative loops

**Before:**
```java
List<String> result = new ArrayList<>();
for (String s : list) {
    if (s.startsWith("a")) {
        result.add(s.toUpperCase());
    }
}
```

**After:**
```java
var result = list.stream()
    .filter(s -> s.startsWith("a"))
    .map(String::toUpperCase)
    .toList();
```

### 4.2 Method references

**Before:**
```java
list.forEach(s -> System.out.println(s));
```

**After:**
```java
list.forEach(System.out::println);
```

### 4.3 Lambdas over anonymous classes

**Before:**
```java
Comparator<String> comparator = new Comparator<>() {
    @Override
    public int compare(String a, String b) {
        return a.length() - b.length();
    }
};
```

**After:**
```java
Comparator<String> comparator = (a, b) -> a.length() - b.length();
```

## 5. Concurrency Modernization

### 5.1 Virtual threads

**Before:**
```java
var executor = Executors.newFixedThreadPool(10);
executor.submit(() -> task.run());
```

**After:**
```java
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    executor.submit(task);
}
```

Only use when the target JDK supports virtual threads.

## 6. Structural Simplification

### 6.1 Inline trivial methods

**Before:**
```java
public boolean isEmpty() {
    return size == 0;
}
```

**After:**
Consider inlining if used once or if the method adds no semantic value.

### 6.2 Remove dead code

Remove unused imports, fields, methods, and unreachable branches.

### 6.3 Simplify nested conditionals

**Before:**
```java
if (a != null) {
    if (b != null) {
        return a + b;
    }
}
return null;
```

**After:**
```java
if (a == null || b == null) {
    return null;
}
return a + b;
```

### 6.4 Use `Optional` or early returns

**Before:**
```java
if (value == null) {
    throw new IllegalArgumentException("value is required");
}
```

**After:**
```java
Objects.requireNonNull(value, "value is required");
```

## 7. Modern `main`

### 7.1 Implicitly declared main class

**Before:**
```java
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello");
    }
}
```

**After:**
```java
void main() {
    System.out.println("Hello");
}
```

Only when the target JDK supports implicitly declared main classes.

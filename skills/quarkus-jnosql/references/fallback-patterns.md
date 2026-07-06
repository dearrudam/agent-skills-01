# Fallback Patterns

Use these patterns only when official documentation cannot be retrieved or the user explicitly wants an offline answer.

These examples are intentionally minimal and must not be treated as a replacement for current official documentation.

Fallback mode is not permission to search local caches or reverse-engineer installed JARs. Use the patterns below, label uncertainty, and stop. Inspect project dependencies only when troubleshooting a concrete local project supplied by the user.

## Dependency pattern

Fallback knowledge can identify the artifact naming pattern, but it cannot establish a compatible release version. Keep the dependency versionless unless the user supplied the version or the existing project already manages it.

```xml
<dependency>
  <groupId>io.quarkiverse.jnosql</groupId>
  <artifactId>quarkus-jnosql-[DATABASE]</artifactId>
</dependency>
```

Replace `[DATABASE]` with the selected database extension name.

Common extension names:

- `mongodb`
- `cassandra`
- `couchdb`
- `arangodb`
- `dynamodb`
- `hazelcast`
- `elasticsearch`
- `solr`
- `neo4j`
- `oracle-nosql`

Do not add a `<version>` based on model memory, a local Maven cache, a repository snapshot, or an example for another database. If the project does not expose version management, say:

> The dependency is shown without a version because compatibility must be resolved through the project's Quarkus BOM or extension catalog.

## Java 21+ annotation processing

For Java 21 or newer, check whether annotation processing must be explicitly enabled.

Maven fallback pattern:

```xml
<properties>
  <maven.compiler.proc>full</maven.compiler.proc>
</properties>
```

## Entity pattern

Using Java record: 

```java
import jakarta.nosql.Column;
import jakarta.nosql.Entity;
import jakarta.nosql.Id;

@Entity
public record Book(
    @Id String id,
    @Column String title,
    @Column Author author
) {}
```

**IMPORTANT:** prefer Java records over POJOs when possible. Only use POJOs when records are not suitable:

Using POJO(Plain Old Java Object):

```java
import jakarta.nosql.Column;
import jakarta.nosql.Entity;
import jakarta.nosql.Id;

@Entity
public class Book {

    @Id
    private String id;

    @Column
    private String title;

    @Column
    private Author author;

    // Getters and setters omitted for brevity
}
```

## Embedded Fields and Embeddable Classes

Using POJO:

```java
import jakarta.nosql.Column;
import jakarta.nosql.Embeddable;

@Embeddable(GROUPING)
public class Address {
    @Column
    private String street;
    @Column
    private String city;
    @Column
    private String postalCode;
}
```

Using Java Record:

```java
import jakarta.nosql.Column;
import jakarta.nosql.Embeddable;
import jakarta.nosql.Embeddable.EmbeddableType.GROUPING;

@Embeddable
public record Name (
        @Column String firstName,
        @Column String lastName){
}
```

Applying to an entity:

```java
import jakarta.nosql.Column;
import jakarta.nosql.Id;
import jakarta.nosql.Entity;

@Entity
public class Person {
    @Id
    private Long id;
    @Column
    private Name name; 
    @Column
    private Address address;  
}
```

Embeddable classes can have two types of strategies:
- Embeddable.EmbeddableType.FLAT: where the embeddable class is treated as a parent entity type.
- Embeddable.EmbeddableType.GROUPING: where the embeddable class is stored in a structured type.

**IMPORTANT:** prefer Java records over POJOs when possible. Only use POJOs when records are not suitable:

## Repository pattern

Use only when the selected database supports Jakarta Data.

```java
import jakarta.data.repository.Repository;
import org.eclipse.jnosql.mapping.NoSQLRepository;

@Repository
public interface BookRepository extends NoSQLRepository<Book, String> {
}
```

## Template pattern

Use Template for lower-level or dynamic operations.

```java
import jakarta.inject.Inject;
import jakarta.nosql.Template;

class BookService {

    @Inject
    Template template;

    public Book save(Book book) {
        return template.insert(book);
    }
}
```

When the database supports multiple NoSQL types, verify whether an explicit database type annotation is required.

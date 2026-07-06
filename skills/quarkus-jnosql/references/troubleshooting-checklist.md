# Troubleshooting Checklist

Use this checklist when the user provides an error, failed build, failed injection, missing repository implementation, native-image failure, or database connection issue.

## First step

Ask for the full error only if the user did not provide enough information to identify the problem. If enough context exists, proceed with a best-effort diagnosis.

## Build or generated class errors

Check:

- Java version
- Maven or Gradle compiler configuration
- Annotation processor execution
- Whether the Quarkus JNoSQL extension was added
- Whether generated classes are being removed by IDE/build configuration

For Java 21+, verify annotation processor setup in the official documentation.

## CDI injection errors

Check:

- Repository annotation
- Template injection type
- Entity annotation
- Package visibility and bean discovery
- Whether the extension artifact matches the target database
- Whether a database type annotation is required for DOCUMENT, COLUMN, GRAPH, or KEY_VALUE

## Repository errors

Check:

- Whether the selected database supports Jakarta Data
- Whether the repository extends the expected JNoSQL/Jakarta Data repository type
- Whether the entity has an ID
- Whether annotation processing generated repository implementations

## Template errors

Check:

- Whether `Template` is the correct abstraction for the database type
- Whether an explicit database type is required
- Whether the entity annotations match the selected NoSQL model

## Configuration errors

Check:

- Database name property
- Host/port/URI properties from the current official database section
- Credentials and authentication settings
- Dev Services/Testcontainers behavior, if relevant
- Whether the property prefix matches the NoSQL database type

## Native-image errors

Check:

- Whether the selected database currently supports native compilation
- Whether the client library requires reflection/resources configuration
- Whether the official database section includes limitations

## Response format for debugging

When diagnosing, respond with:

1. Most likely cause
2. Evidence from the error
3. Documentation section to verify
4. Minimal fix
5. One validation command

# Agent Skills 01

Reusable agent skills for AI-assisted software delivery workflows, spec-driven Java development, Spring Boot and Quarkus work, BCE migration, and repository operations.

## Skill Catalog

| Skill | Purpose |
| --- | --- |
| [`sldd`](skills/sldd/README.md) | Routes SLDD workflows through gated intent, design, test, implementation, and verification steps. |
| [`sdd4j`](skills/sdd4j/README.md) | Drives Spec-Driven Development for Java with `package-info.java` capability specs, EARS requirements, and traceable verification. |
| [`sdd4j-package-by-feature`](skills/sdd4j-package-by-feature/README.md) | Maps SDD4J capabilities to co-located Java feature packages. |
| [`sdd4j-package-by-layer`](skills/sdd4j-package-by-layer/README.md) | Maps SDD4J capabilities to technical layer packages such as controller, service, repository, model, domain, and DTO. |
| [`sdd4j-bce`](skills/sdd4j-bce/README.md) | Maps SDD4J capabilities to Boundary-Control-Entity business components. |
| [`sdd4j-ears-tests`](skills/sdd4j-ears-tests/README.md) | Generates grep-traceable Java tests from SDD4J EARS requirement groups and statement ids. |
| [`migrate-to-bce`](skills/migrate-to-bce/README.md) | Plans and applies incremental BCE migrations, including SBCE/SDD4J spec reverse engineering with test ID backfill. |
| [`spring-boot-server`](skills/spring-boot-server/README.md) | Defines stack-specific rules for long-running Java Spring Boot servers while preserving the project's selected architecture. |
| [`quarkus-jnosql`](skills/quarkus-jnosql/README.md) | Guides Quarkus applications that use Quarkus JNoSQL, Eclipse JNoSQL, Jakarta NoSQL, or Jakarta Data repositories. |
| [`conventional-commit`](skills/conventional-commit/README.md) | Analyzes staged git diffs and generates Conventional Commit messages. |

## Install With The Skills CLI

```bash
npx skills add dearrudam/agent-skills-01
```

## Install With `installSkills`

The installer requires Java 25+:

```bash
./installSkills
```

By default, skills are installed to `${HOME}/.agents/skills`. Use `--target <skills-dir>` to choose another destination:

```bash
./installSkills --target ~/.claude/skills
```

Use `--copy` to install copies instead of symlinks:

```bash
./installSkills --copy
```

The installer discovers skill directories under `skills/`, prompts before installing each selected skill, removes previous entries for selected skills in the target directory, and writes each skill to `<target>/<skill-name>`. Reload the consuming tool after changing installed skills.

## Install Manually

Install manually for Claude Code:

```bash
git clone https://github.com/dearrudam/agent-skills-01.git
cp -rf agent-skills-01/skills/* ~/.claude/skills/
```

Install manually for OpenCode or Codex:

```bash
git clone https://github.com/dearrudam/agent-skills-01.git
cp -rf agent-skills-01/skills/* ~/.agents/skills/
```

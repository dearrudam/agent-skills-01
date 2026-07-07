# Agent Skills 01

Reusable agent skills for AI-assisted software delivery workflows, Java/Quarkus development, and repository operations.

## Skills

| Skill | Purpose |
| --- | --- |
| [`sldd`](skills/sldd/README.md) | Routes Spec Loops Driven Development workflows through gated intent, design, test, implementation, and verification steps. |
| [`sdd4j`](skills/sdd4j/SKILL.md) | Drives Spec-Driven Development for Java with `package-info.java` specs, EARS requirements, traceable tests, and pluggable architecture adapters. |
| [`sdd4j-package-by-feature`](skills/sdd4j-package-by-feature/SKILL.md) | Maps SDD4J capabilities to co-located Java feature packages. |
| [`sdd4j-package-by-layer`](skills/sdd4j-package-by-layer/SKILL.md) | Maps SDD4J capabilities to layered Java projects with controller/service/repository/model-style packages. |
| [`sdd4j-bce`](skills/sdd4j-bce/SKILL.md) | Maps SDD4J capabilities to Boundary-Control-Entity business components with `boundary`, `control`, and `entity` layers. |
| [`sdd4j-ears-tests`](skills/sdd4j-ears-tests/SKILL.md) | Generates traceable Java tests from SDD4J EARS requirement groups and statement ids. |
| [`spring-boot-server`](skills/spring-boot-server/SKILL.md) | Provides stack-specific coding rules for long-running Java Spring Boot servers, covering Spring MVC, Spring DI, Jackson, validation, observability, security, persistence integration, and test slices while preserving the project's chosen architecture. |
| [`quarkus-jnosql`](skills/quarkus-jnosql/SKILL.md) | Helps create, review, migrate, troubleshoot, or explain Quarkus applications that use Quarkus JNoSQL, Eclipse JNoSQL, Jakarta NoSQL, or Jakarta Data repositories. |
| [`conventional-commit`](skills/conventional-commit/SKILL.md) | Analyzes staged git diffs and generates Conventional Commit messages for committing changes. |

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

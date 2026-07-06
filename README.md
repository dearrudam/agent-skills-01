# Agent Skills 01

Reusable agent skills for AI-assisted software delivery workflows, Java/Quarkus development, and repository operations.

## Skills

| Skill | Purpose |
| --- | --- |
| [`sldd`](skills/sldd/README.md) | Routes Spec Loops Driven Development workflows through gated intent, design, test, implementation, and verification steps. |
| [`sdd4j-package-by-feature`](skills/sdd4j-package-by-feature/SKILL.md) | Maps SDD4J capabilities to co-located Java feature packages. |
| [`sdd4j-package-by-layer`](skills/sdd4j-package-by-layer/SKILL.md) | Maps SDD4J capabilities to layered Java projects with controller/service/repository/model-style packages. |
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

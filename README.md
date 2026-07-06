# Agent Skills 01

This repo contains the following agent skills:

- [`skills/sldd`](skills/sldd/README.md): SLDD is a runtime skill for **Spec Loops Driven Development**: a gated, specs-driven workflow for AI-assisted software delivery.
- [`skills/quarkus-jnosql`](skills/quarkus-jnosql/SKILL.md): Quarkus JNoSQL Skill to help the agent when the user wants to create, review, migrate, troubleshoot, or explain Quarkus applications using the Quarkus JNoSQL extension, Eclipse JNoSQL, Jakarta NoSQL, or Jakarta Data repositories.
- [`skills/conventional-commit`](skills/conventional-commit/SKILL.md): Conventional Commit Skill to help the agent when the user wants to commit, craft a commit message, stage changes, or split work into multiple commits.

## Install using the Skills CLI

```bash
npx skills add dearrudam/agent-skills-01
```

## Install using installSkills script

It requires Java 25+:

```bash
./installSkills
```

The default skills directory is `${HOME}/.agents/skills`. Use `--target <skills-dir>` to choose another skills directory:

```bash
./installSkills --target ~/.claude/skills
```

Use `--copy` to install a copy instead of a symlink:

```bash
./installSkills --copy
```

The installer discovers skill directories under `skills/`, prompts before installing each skill, defaults to `$HOME/.agents/skills`, removes previous entries for each selected skill in the target directory, and creates installed skills at `<target>/<skill-name>`. Reload the consuming tool after changing installed skills.

## Install manually

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

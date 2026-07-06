---
id: conventional-commit
name: Conventional Commit Generator
description: Analyzes git diffs and commits staged changes using Conventional Commits v1.0.0.1. Use when the user asks to commit, craft a commit message, stage changes, or split work into multiple commits.

version: 1.0.0
---

# Conventional Commit Skill

## Prerequisites
* The agent must have shell access to run `git` commands.
* Code changes must be present in the git staging area.

## Execution Steps
1. **Analyze**: Run `git diff --cached` to extract the staged code changes.
2. **Classify**: Determine the commit type based on the modifications:
    - `feat`: A new feature
    - `fix`: A bug fix
    - `docs`: Documentation only changes
    - `style`: Changes that do not affect the meaning of the code
    - `refactor`: A code change that neither fixes a bug nor adds a feature
    - `test`: Adding missing tests or correcting existing tests
    - `chore`: Changes to the build process or auxiliary tools
3. **Format**: Draft a message strictly following: `<type>(<optional-scope>): <description>`
    - Use the imperative mood (e.g., "add", not "added").
    - Limit the subject line to 50 characters.
4. **Confirm**: Display the generated message to the user and ask for explicit confirmation.
5. **Commit**: Run `git commit -m "<message>"` upon approval.

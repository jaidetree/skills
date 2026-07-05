Quickstart:

```bash
npx skills add mattpocock/skills --skill=new-vault-project
```

```bash
npx skills update new-vault-project
```

[Source](https://github.com/mattpocock/skills/tree/main/skills/engineering/new-vault-project)

## What it does

`new-vault-project` scaffolds a new project directory in the vault (`vault/Projects/<slug>/`) from the bundled template. It runs the `new-project.sh` script from the `setup-project-vault` skill, which copies the template, renames the kanban board file, and repoints the board's `columnRoot` at the new path.

## When to reach for it

The agent reaches for it automatically — via the `docs/agents/issue-tracker.md` receipt — whenever `to-prd` or `to-issues` publishes to the vault tracker and the project directory doesn't yet exist.

Reach for it directly (`/new-vault-project <slug>`) when you want to create the project directory without publishing a PRD or issues yet.

## Prerequisites

`setup-project-vault` must have been run in the repo: the vault must be cloned and `docs/agents/issue-tracker.md` must be in place.

## It's working if

- `vault/Projects/<slug>/` was created.
- `vault/Projects/<slug>/<slug>.base` (the kanban board) is present.

## Where it fits

A utility in the `setup-project-vault` chain, called within the `to-prd → to-issues → slice` publishing flow. For the full map, see [ask-matt](https://aihero.dev/skills-ask-matt).

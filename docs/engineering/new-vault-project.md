Quickstart:

```bash
npx skills add mattpocock/skills --skill=new-vault-project
```

```bash
npx skills update new-vault-project
```

[Source](https://github.com/mattpocock/skills/tree/main/skills/engineering/new-vault-project)

## What it does

`new-vault-project` scaffolds a new project directory in the vault from the bundled template. It reads the vault dir name from `docs/agents/issue-tracker.md` (the `vault_dir:` frontmatter field written by `setup-project-vault`), then runs `new-project.sh` to copy the template, rename the kanban board file, and repoint the board's `columnRoot` at the new path.

## When to reach for it

The agent reaches for it automatically — via the `docs/agents/issue-tracker.md` receipt — whenever `to-spec` or `to-tickets` publishes to the vault tracker and the project directory doesn't yet exist.

Reach for it directly (`/new-vault-project <slug>`) when you want to create the project directory without publishing a spec or issues yet.

## Prerequisites

`setup-project-vault` must have been run in the repo: the vault must be cloned and `docs/agents/issue-tracker.md` must be in place.

## It's working if

- `<vault-dir>/Projects/<slug>/` was created.
- `<vault-dir>/Projects/<slug>/<slug>.base` (the kanban board) is present.

## Where it fits

A utility in the `setup-project-vault` chain, called within the `to-spec → to-tickets → slice` publishing flow. For the full map, see [ask-matt](https://aihero.dev/skills-ask-matt).

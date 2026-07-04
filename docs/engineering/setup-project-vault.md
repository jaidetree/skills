Quickstart:

```bash
npx skills add mattpocock/skills --skill=setup-project-vault
```

```bash
npx skills update setup-project-vault
```

[Source](https://github.com/mattpocock/skills/tree/main/skills/engineering/setup-project-vault)

## What it does

`setup-project-vault` clones an [Obsidian project vault](https://github.com/jaidetree/obsidian-project-vault) into your repo and wires the engineering skills to use it as the home for ADRs, PRDs, and issues.

It is the vault-first counterpart to [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills): it emits the same `docs/agents/*.md` receipts, so nothing downstream changes — but the tracker it configures is a folder of markdown that Obsidian renders as a kanban board. In that model a ticket's development state **is the folder it sits in**, while its triage role is a frontmatter `tags:` value — the two are orthogonal. ADRs move to `vault/ADRs`.

## When to reach for it

You invoke this by typing `/setup-project-vault` — the agent won't reach for it on its own.

Reach for it **once per repo**, when you want your issues and decisions to live in Obsidian rather than GitHub. For GitHub/GitLab/local-markdown tracking instead, use [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills) — run one or the other, not both.

## Prerequisites

None to start — it clones the vault for you. It writes into your repo: a committed `vault/` directory, `docs/agents/*.md` receipts, and an `## Agent skills` block in `CLAUDE.md`/`AGENTS.md`.

## Two things it leaves behind

- **The vault as tracker.** Issues live as markdown under `vault/Projects/<slug>/`. Agents resolve tickets by filename stem (never the folder path, which goes stale as cards move); humans drag cards on the board. New issues land in `Backlog` tagged `ready-for-agent`.
- **A generated `/slice` skill.** A project-local `.claude/skills/slice/SKILL.md`, filled with your build/test/lint commands and module rules, that takes one slice `Ready → In Progress → implement → commit → Review`. It bakes the workflow in so a fresh session doesn't re-learn it — and it owns the folder moves, so the global [implement](https://aihero.dev/skills-implement) skill stays tracker-agnostic.

## It's working if

- A committed `vault/` appears, with `ADRs/`, `Knowledge/`, `Library/`, and (if it's your tracker) `Projects/`.
- `docs/agents/*.md` and an `## Agent skills` block exist, with ADRs pointed at `vault/ADRs`.
- A `.claude/skills/slice/` skill exists with no `{{...}}` placeholders left in it.

## Where it fits

A **run-once setup**, the entry point to the engineering chain (`setup → to-prd → to-issues → slice → code-review`) for repos that track work in Obsidian. Its sibling is [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills), the same bootstrap for GitHub/GitLab/local trackers — choose by where you want your issues to live. For the whole map, see [ask-matt](https://aihero.dev/skills-ask-matt).

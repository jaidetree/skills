## What it does

`setup-project-vault` clones an [Obsidian project vault](https://github.com/jaidetree/obsidian-project-vault) into your repo and wires the engineering skills to use it as the home for ADRs, specs, and issues.

It is the vault-first counterpart to [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills): it emits the same `docs/agents/*.md` receipts (plus one of its own, `vault.md`, recording where the vault lives), so nothing downstream changes, but the tracker it configures is a folder of markdown that Obsidian renders as a kanban board. In that model a ticket's development state **is the folder it sits in**, while its triage role is a frontmatter `tags:` value: the two are orthogonal. The glossary moves to `<vault-dir>/Domain/GLOSSARY.md` and ADRs to `<vault-dir>/ADRs`.

It does not generate project-local `/slice` or `/afk` skills. Those are static skills in this set; they read each project's `Workflow.md`.

## When to reach for it

You invoke this by typing `/setup-project-vault`. The [agent](https://www.aihero.dev/ai-coding-dictionary/agent) won't reach for it on its own.

Reach for it **once per repo**, when you want your issues and decisions to live in Obsidian rather than GitHub. For GitHub/GitLab/local-markdown tracking instead, use [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills). Run one or the other, not both.

## Prerequisites

None to start. It clones the vault for you. It writes into your repo: a committed vault directory (named after your repo directory with a leading dot, e.g. `.my-project-vault`), `docs/agents/*.md` receipts, and an `## Agent skills` block in `CLAUDE.md`/`AGENTS.md`.

## What it leaves behind

- **The vault as tracker.** Issues live as markdown under `<vault-dir>/Projects/<slug>/`. Agents resolve tickets by filename stem (never the folder path, which goes stale as cards move); humans drag cards on the board. New issues land in `Backlog` tagged `ready-for-agent`. Each project includes a `Workflow.md` template, filled later by [to-workflow](https://aihero.dev/skills-to-workflow).
- **Receipts, not generated skills.** `docs/agents/*.md` tell [slice](https://aihero.dev/skills-slice) and [afk](https://aihero.dev/skills-afk) where the vault is. Older setups that wrote `.claude/skills/slice` and `.claude/skills/afk` can delete those directories after copying any baked commands into `Workflow.md`.

## Common questions

**I already have `.claude/skills/slice` from the old setup. Do I keep it?**
The static skills supersede it. Run [to-workflow](https://aihero.dev/skills-to-workflow) so baked build/test commands land in `Workflow.md`, then delete the generated copy.

## It's working if

- A committed vault directory (e.g. `.my-project-vault/`) appears, with `ADRs/`, `Domain/`, `Knowledge/`, `Library/`, and (if it's your tracker) `Projects/`.
- `docs/agents/*.md` and an `## Agent skills` block exist, with the glossary pointed at `<vault-dir>/Domain/GLOSSARY.md` and ADRs at `<vault-dir>/ADRs`.
- `docs/agents/vault.md` names your vault dir in its `vault_dir:` frontmatter: this is how `/knowledge`, `/new-vault-project`, `/slice`, and `/afk` find the vault.
- Setup did not write `.claude/skills/slice/` or `.claude/skills/afk/`.

## Where it fits

A **run-once setup**, the entry point to the vault chain (`setup → to-spec → to-tickets → to-workflow → slice` or `afk`). Its sibling is [setup-matt-pocock-skills](https://aihero.dev/skills-setup-matt-pocock-skills), the same bootstrap for GitHub/GitLab/local trackers. For the whole map, see [ask-matt](https://aihero.dev/skills-ask-matt).

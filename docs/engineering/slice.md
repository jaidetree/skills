## What it does

`slice` takes one vault-tracked ticket from claimed to committed: `In Progress` → implement → the **per-ticket checks** in `Workflow.md` → commit → `Review`.

It runs only those cheap checks. The **gate** (full suite, `green-ci`) is a project-level step on the feature branch, owned by [afk](https://aihero.dev/skills-afk), not by each ticket.

## When to reach for it

Type `/slice <issue>`, or the [agent](https://www.aihero.dev/ai-coding-dictionary/agent) reaches for it when [afk](https://aihero.dev/skills-afk) dispatches a ticket (it is model-invoked so that dispatch works).

| Where you are | What to run |
| --- | --- |
| One vault ticket, you will verify it | `/slice <NN-slug>` |
| The whole vault project, unattended | [afk](https://aihero.dev/skills-afk) after [to-workflow](https://aihero.dev/skills-to-workflow) |
| GitHub or local-markdown tickets | [implement](https://aihero.dev/skills-implement) |

## Prerequisites

A vault from [setup-project-vault](https://aihero.dev/skills-setup-project-vault) and a project with tickets. `Workflow.md` may still be the template: per-ticket checks then mean `none`. [afk](https://aihero.dev/skills-afk) is the skill that refuses an unfilled file.

## Per-ticket checks, not the gate

`Workflow.md` splits verification in two. **Per-ticket checks** are what every concurrent worktree can afford (often none). The **gate** runs once, after the last wave. `slice` never runs the gate.

A human `/slice` leaves the ticket in `Review`. Unattended Close (`Review` → `Done` when cheap checks pass) is [afk](https://aihero.dev/skills-afk) after it merges the worktree.

## Common questions

**Do I still need the generated `.claude/skills/slice` from an older setup?**
No. That copy is superseded. Copy any baked commands into `Workflow.md` with [to-workflow](https://aihero.dev/skills-to-workflow), then delete the generated directory.

**Why didn't it run `green-ci`?**
`green-ci` belongs under Final verification. Running it here is how parallel worktrees used to take hours.

## It's working if

- The ticket file moved `Ready` (or `Backlog`) → `In Progress` → `Review`.
- The only commands that ran after implement match Per-ticket checks, or nothing ran if that heading is `none`.
- A human `/slice` did not move the ticket to `Done`.

## Where it fits

A **chain step** on the vault path, the one-ticket worker [afk](https://aihero.dev/skills-afk) dispatches. Upstream is [to-workflow](https://aihero.dev/skills-to-workflow). For GitHub-tracker work, [implement](https://aihero.dev/skills-implement) is the sibling. For the whole map, see [ask-matt](https://aihero.dev/skills-ask-matt).

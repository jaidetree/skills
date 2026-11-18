## What it does

`afk` drives a vault project unattended. It reads `Workflow.md` and follows it: **waves** of tickets in parallel worktrees, cheap per-ticket checks via [slice](https://aihero.dev/skills-slice), merge onto one feature branch, then one **gate** after the last wave.

The root [agent](https://www.aihero.dev/ai-coding-dictionary/agent) only routes. Implement, ticket bodies, and build logs stay in [subagents](https://www.aihero.dev/ai-coding-dictionary/subagent) with a fresh [context window](https://www.aihero.dev/ai-coding-dictionary/context-window). It does not open a PR; a repo-local `/ship` can do that afterwards.

## When to reach for it

You invoke this by typing `/afk` (optionally with a project slug). The agent won't reach for it on its own.

| Where you are | What to run |
| --- | --- |
| Vault tickets exist and `Workflow.md` is filled | `/afk` or `/afk <slug>` |
| `Workflow.md` is still the template | [to-workflow](https://aihero.dev/skills-to-workflow) first; this skill stops |
| One ticket, you will verify it | [slice](https://aihero.dev/skills-slice) |
| GitHub or local-markdown tickets, whole spec | [implement-spec](https://aihero.dev/skills-implement-spec) |

## Prerequisites

A vault tracker from [setup-project-vault](https://aihero.dev/skills-setup-project-vault), tickets from [to-tickets](https://aihero.dev/skills-to-tickets), and a **filled** `Workflow.md` from [to-workflow](https://aihero.dev/skills-to-workflow). Unfilled means the file is missing or still contains "`/to-workflow` fills this file".

## Waves and the gate

A **wave** is a set of tickets that do not block each other. `afk` dispatches a whole wave at once, merges each worktree into the feature branch (no gate there), then starts the next wave. After the last wave it runs Final verification **once**.

Close comes from `Workflow.md`: unattended runs move a ticket to `Done` when per-ticket checks pass. Stragglers stay in `Review` with a one-line reason; their diff still merges.

Environment lists missing MCPs up front so you can connect them while waves run.

## Common questions

**Will it run `green-ci` on every worktree?**
No. That command belongs under Final verification, once. That was the bottleneck this split exists to prevent.

**Do I still need the generated `.claude/skills/afk` from an older setup?**
No. Copy any baked commands into `Workflow.md` with [to-workflow](https://aihero.dev/skills-to-workflow), then delete the generated directory.

**Does `/afk` open the PR?**
No. It stops at a verified feature branch plus `MANUAL-TESTING.md`. Snapps `/ship` (and similar overlays) kick off the tracker ticket and draft the PR around this skill.

## It's working if

- `/afk` on an unfilled `Workflow.md` stops and names [to-workflow](https://aihero.dev/skills-to-workflow).
- Tickets in one wave run in parallel worktrees; the expensive suite runs once, after the last wave.
- Missing MCPs appear in the first report, before implementers finish.
- The feature branch exists; no PR opened unless something else did it.

## Where it fits

A **chain step** on the vault path: `to-spec → to-tickets → to-workflow → afk`. Upstream is [to-workflow](https://aihero.dev/skills-to-workflow). Each ticket is built by [slice](https://aihero.dev/skills-slice). The GitHub-tracker sibling is [implement-spec](https://aihero.dev/skills-implement-spec). For the whole map, see [ask-matt](https://aihero.dev/skills-ask-matt).

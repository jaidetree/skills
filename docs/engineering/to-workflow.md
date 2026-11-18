## What it does

`to-workflow` takes a vault project's tickets and writes `Workflow.md`: **waves** of tickets that can run in parallel, the cheap checks each worktree is allowed, and one verification **gate** on the feature branch.

`/afk` and `/slice` follow that file. The skill does not implement anything. It records how this project ships, so the implementers never guess a process, and never pay for the repo's full suite on every concurrent worktree.

## When to reach for it

You invoke this by typing `/to-workflow`. The [agent](https://www.aihero.dev/ai-coding-dictionary/agent) won't reach for it on its own.

| Where you are | What to run |
| --- | --- |
| Vault tickets exist, you are about to `/afk` or `/ship` | `/to-workflow` |
| The spec is written but tickets are not | [to-tickets](https://aihero.dev/skills-to-tickets) first |
| You are working one ticket yourself | skip this; a human `/slice` leaves the ticket in `Review` for you |
| The tracker is GitHub or local markdown, not the vault | this skill does not apply; [implement-spec](https://aihero.dev/skills-implement-spec) is the parallel path |

## Prerequisites

A vault tracker from [setup-project-vault](https://aihero.dev/skills-setup-project-vault), and a project directory from [new-vault-project](https://aihero.dev/skills-new-vault-project) (usually created for you by [to-spec](https://aihero.dev/skills-to-spec) or [to-tickets](https://aihero.dev/skills-to-tickets)). The project needs a [spec](https://www.aihero.dev/ai-coding-dictionary/spec) and [tickets](https://www.aihero.dev/ai-coding-dictionary/ticket) so the waves can be computed from `blocked_by`.

## Waves and the gate

A **wave** is every ticket whose blockers are already in an earlier wave (or that has no blockers). Tickets in the same wave do not block each other, so they are safe to run in parallel worktrees.

The **gate** is the one expensive pass after the last wave, on the feature branch: `green-ci`, the full suite, or nothing, whatever this project actually needs. Per-ticket checks stay cheap (often none) so five concurrent agents are not each running a 10-minute suite.

`to-workflow` looks up facts (ticket graph, default branch, connected MCP servers, scripts the repo has), drafts every heading, then runs [grilling](https://aihero.dev/skills-grilling) on the remaining decisions. It writes the file only after you confirm a shared understanding.

## Common questions

**Can I skip this and go straight to `/afk`?**
`/afk` stops if `Workflow.md` is still the template. The empty file is the signal that no one has chosen a gate yet, which is how per-worktree full-suite runs used to sneak back in.

**Does every ticket become its own PR?**
That is a grilled decision. The default is one feature branch and one PR, with the parent tracker issue (Jira, GitHub) as the PR's parent. Split into several PRs when the tickets will not review as one change.

**Where does `green-ci` run?**
Only under Final verification, once, after the last wave. Putting it on every worktree is the bottleneck this skill exists to prevent.

## It's working if

- `Projects/<slug>/Workflow.md` has a project-specific sentence under every heading, not the template placeholders.
- The waves match the tickets' `blocked_by` graph: nothing in wave 2 is still blocked by something also in wave 2.
- Per-ticket checks are `none` or a short cheap command, and the expensive suite is named only under Final verification.
- Required MCP servers are listed as `connected` or `missing`, and missing ones are in the handback as work you can do while waves run.

## Where it fits

A **chain step** on the vault path: `wayfinder → to-spec → to-tickets → to-workflow → afk` (or `/ship`, when that is a repo-local overlay). Upstream is [to-tickets](https://aihero.dev/skills-to-tickets). Downstream, `/afk` reads `Workflow.md` and will not start on the template. For the whole map, see [ask-matt](https://aihero.dev/skills-ask-matt).

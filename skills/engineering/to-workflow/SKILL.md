---
name: to-workflow
description: Grill a vault project's waves, cheap checks, and one final verification gate into Workflow.md.
disable-model-invocation: true
---

# To Workflow

Turn a vault project's tickets into a **workflow**: **waves** of parallel work, cheap per-ticket checks, and one **gate** on the feature branch. Write it to `Workflow.md`. That file is the process `/afk` and `/slice` follow.

This skill is for vault-tracked projects. If `docs/agents/vault.md` is absent, tell the user to run `/setup-project-vault` and stop.

## Process

### 1. Resolve the project

Read `docs/agents/vault.md` for `vault_dir`. Resolve the project slug from the argument, the spec path, or the sole directory under `<vault-dir>/Projects/` (ask if more than one). Confirm `<vault-dir>/Projects/<slug>/` exists; if it does not, tell the user to run `/new-vault-project` and stop.

If `Workflow.md` is missing, copy it from `<vault-dir>/Templates/Project/<project-name>/Workflow.md`. If that template is missing too (an older vault), create `Workflow.md` with the headings in **Headings**.

_Done: vault dir, slug, and a `Workflow.md` path are known._

### 2. Gather facts

Load `Spec.md` and every issue under `issues/**` (stem, folder, `blocked_by`, tags). Compute **waves**: wave 1 is every ticket with no unfinished blocker; each later wave is the tickets whose blockers all sit in earlier waves.

Look these up in the environment:

- Merge base (`git symbolic-ref refs/remotes/origin/head` or the repo's default branch) and a feature-branch name derived from the slug
- Parent tracker id on the spec or tickets, if one is already written
- Test and CI commands the repo actually has (`package.json` scripts, a `green-ci` skill, Makefile targets)
- MCP servers connected in this session, matched against what the tickets need (GitHub, Jira, Slack, browser, …)

_Done: every ticket stem is in a wave, and the lookup results are in hand._

### 3. Draft, then grill

Draft every heading in `Workflow.md` (see **Headings**). Defaults unless a fact contradicts them:

- One feature branch, one PR, parent tracker issue as the PR's parent
- Per-ticket checks: none
- Integrate: merge each worktree into the feature branch
- Gate: the repo's expensive verification, once, after the last wave
- Close: unattended (`/afk`, `/ship`) moves a ticket to `Done` when its cheap checks pass and the acceptance criteria check out from the diff; a human-invoked `/slice` leaves it in `Review`
- Environment: each required MCP listed as connected or missing, plus known local traps

Call the Skill tool with "grilling". Treat the draft as the recommended answers. Grill only the remaining decisions (PR grouping, whether any cheap check is worth a wave, what the gate is, close policy). Facts already looked up are settled.

_Done: the user has confirmed a shared understanding._

### 4. Write `Workflow.md`

Replace every placeholder sentence with the agreed values. A heading still carrying the template's explanatory prose is not done.

_Done: every heading has a project-specific value._

### 5. Hand back parallel work

Report the path, the waves, the gate, and anything the human can start **now** while `/afk` runs: missing MCPs to connect, a local stack update, env files, flags that only a human can flip.

_Done: that list is in the reply, or the reply says there is nothing for the human to do in parallel._

## Headings

`Workflow.md` is the source of truth for shape. Fill all of:

| Heading | What a filled value looks like |
| --- | --- |
| Parent | Tracker id the PR belongs to, or `none` |
| Branch | Feature-branch name and merge base |
| Waves | Ordered groups of ticket stems; tickets in one wave do not block each other |
| Per-ticket checks | Cheap commands each worktree may run, or `none` |
| Integrate | Merge worktrees into the feature branch |
| Final verification | The **gate**: one expensive pass after the last wave |
| Close | Unattended → `Done` on cheap pass; human `/slice` → `Review` |
| How to test locally | Flags (browser vs server), restarts, env quirks |
| Environment | Local traps, and each required MCP as `connected` or `missing` |

The full suite and `green-ci` live only under Final verification. Per-ticket checks stay cheap enough that every concurrent worktree can run them without becoming the bottleneck.

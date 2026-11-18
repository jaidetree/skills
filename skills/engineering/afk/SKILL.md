---
name: afk
description: Drive a vault project unattended from Workflow.md waves, cheap per-ticket checks, and one verification gate on the feature branch.
disable-model-invocation: true
---

# AFK

Drive a vault project to completion unattended. `Workflow.md` is the process: **waves** in parallel, cheap per-ticket checks, one **gate** after the last wave.

The root agent **routes**. It does not implement, does not read ticket bodies or Specs, and does not hold build logs. Start every subagent with a fresh context window.

If `docs/agents/vault.md` is absent, tell the user to run `/setup-project-vault` and stop.

## Steps

1. **Resolve the project.** `vault_dir` from `docs/agents/vault.md`. Slug from the argument, or the sole directory under `<vault-dir>/Projects/` (ask if more than one).

2. **Require a filled `Workflow.md`.** Path: `<vault-dir>/Projects/<slug>/Workflow.md`. **Unfilled** means missing or still containing "`/to-workflow` fills this file". If unfilled, tell the user to run `/to-workflow` and stop.

3. **Surface Environment.** Report every required MCP listed `missing`, and any local traps the human can start **now**. Continue; those run in parallel with waves.

4. **Feature branch.** Create or check out the Branch heading's feature branch from its merge base.

5. **Waves, in order.** For each wave in `Workflow.md`:
   1. Skip stems already in `Done/`. Skip stems whose `blocked_by` is a straggler this run.
   2. One fresh subagent per remaining stem, each in its own worktree branched from the feature branch. Tell it to call the Skill tool with "slice" on that stem, and to hand back only: stem, branch, worktree, `SCOPED_CHECK`, manual-test stubs.
   3. **Integrate** as each reports, in dispatch order, following the Integrate heading (merge into the feature branch; no gate here). Finish an in-progress merge rather than aborting. Delete the worktree.
   4. **Close.** If Close says unattended and `SCOPED_CHECK` is `pass` or `none`, move `Review` → `Done` and commit that move. Otherwise leave it in `Review`, log it as a **straggler** with one line of why, and still keep the merged diff.

6. **Gate.** After the last wave, run Final verification once on the feature branch. Fix failures in a fresh subagent on that branch. Root records pass/fail, not logs.

7. **Manual testing guide.** Write `<vault-dir>/Projects/<slug>/MANUAL-TESTING.md` from How to test locally plus the collected stubs (one section per `Done` ticket). Commit it.

8. **Report.** Shipped stems, stragglers (`stem` + why), pointer to the guide, feature branch. No PR; a repo-local `/ship` does that.

_Done: every wave has been dispatched or skipped, the gate has been run (or was `none`), and the report is in the reply._

---
name: slice
description: >-
  Take one vault-tracked ticket from In Progress through implement, Workflow.md
  per-ticket checks, commit, and Review. Use when the user says /slice, do
  slice N, work issue N, or when afk dispatches a ticket.
---

# Slice

Take one vault-tracked ticket: In Progress → implement → **per-ticket checks** from `Workflow.md` → commit → `Review`.

`Workflow.md` is the process. The **gate** (full suite, `green-ci`) lives there under Final verification; this skill runs only Per-ticket checks.

If `docs/agents/vault.md` is absent, tell the user to run `/setup-project-vault` and stop.

## Steps

1. **Resolve.** Read `vault_dir` from `docs/agents/vault.md`. Argument is a `NN-slug` stem or number, optionally `<project-slug>/<issue>`. Find the file under `<vault-dir>/Projects/*/issues/**` by stem (zero-pad numbers to two digits). Folder = current dev state. If a project slug was given, search only there; if the stem matches more than one project, or there is no argument, stop and ask.

2. **Read.** The ticket, `Spec.md`, `Workflow.md`, `Domain/GLOSSARY.md` (or `GLOSSARY-MAP.md`), and any ADRs it touches. Stop if the ticket is missing.

   `Workflow.md` is **unfilled** when it is missing or still contains "`/to-workflow` fills this file". An unfilled file means Per-ticket checks are `none`; still implement. `/afk` is the skill that refuses an unfilled file.

3. **Claim.** Move the ticket from `Ready` or `Backlog` → `In Progress`. If `<vault-dir>` is gitignored, do this in the main checkout; if it is tracked, do it in this worktree.

4. **Implement.** Build the ticket. Call the Skill tool with "tdd" at the seams the ticket names. Follow repo conventions already in `AGENTS.md` / `CLAUDE.md`.

5. **Per-ticket checks.** Run exactly the commands under Per-ticket checks (`none` means skip). On failure, fix and **goto 4**.

6. **Commit** the ticket's own files. Skip if nothing to commit.

7. **Review.** Move `In Progress` → `Review`. Check off acceptance-criteria boxes that now hold. This skill leaves the ticket in `Review`; `/afk` applies Close after integrate.

8. **Hand back** the stem, branch, worktree path, `SCOPED_CHECK: pass|fail|none`, and any manual-test steps from How to test locally that this ticket touches.

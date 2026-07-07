---
name: setup-project-vault
description: Configure this repo to use an Obsidian project vault — clone the vault, optionally make it the issue tracker, and wire ADRs/PRDs/issues into it. Vault-first alternative to setup-matt-pocock-skills. Run once per repo.
disable-model-invocation: true
---

# Setup Project Vault

Clone an [Obsidian project vault](https://github.com/jaidetree/obsidian-project-vault) into this repo and wire the engineering skills to it. The vault is a human-friendly (Obsidian) + agent-friendly home for ADRs, PRDs, and issues.

Emits the same `docs/agents/*.md` receipts as `setup-matt-pocock-skills`, so consuming skills need no changes.

Prompt-driven: explore, present, confirm, then write.

## Process

### 1. Explore

- `git remote -v` — GitHub? GitLab? none?
- `CLAUDE.md` / `AGENTS.md` at root — which exists? Existing `## Agent skills` block?
- `docs/agents/` — prior receipts?
- Build/test/lint commands (`package.json` scripts, Makefile, etc.) and module/structure conventions — needed to fill the `/slice` skill in step 6.
- **Derive a vault dir name:** take the repo's directory name — `basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"` — and format it as `.<dir-name>-vault` (leading dot, `-vault` suffix; e.g. `tasky` → `.tasky-vault`). The dot hides the nested vault from any parent Obsidian vault's file explorer while `.<dir-name>-vault` still opens directly as its own, clearly-named vault. **Propose this name and stop for confirmation** — present it as the default and ask the user to confirm it or type a different name before cloning. **Check that no directory with this name already exists** (same confirm-before-overwrite rule as step 2).

### 2. Clone the vault

Run `./clone-vault.sh <vault-dir>` (from this skill folder), using the name confirmed in step 1. Strips `.git` so vault files become plain files in this repo. If the dir exists, confirm before overwriting.

The vault hosts `<vault-dir>/ADRs/`, `<vault-dir>/Knowledge/`, `<vault-dir>/Library/` regardless of the tracker choice below.

### 3. Ask: use the vault as the issue tracker?

> Explainer: If yes, PRDs and issues live in the vault as markdown under `<vault-dir>/Projects/<slug>/`, with a visual kanban board (Obsidian Bases). If no, keep tracking issues on GitHub/GitLab/local markdown — the vault is still the home for ADRs and knowledge notes.

Default: **yes**.

If **no**, ask the tracker inline (GitHub / GitLab / local markdown) and write `docs/agents/issue-tracker.md` from the matching seed in `../setup-matt-pocock-skills/` (`issue-tracker-github.md` / `-gitlab.md` / `-local.md`). Do **not** send the user to run a second setup skill.

### 4. Confirm triage labels

The five canonical roles come from `../setup-matt-pocock-skills/triage-labels.md` (shared vocabulary). In the vault these roles are applied as frontmatter `tags:` on issue files, not tracker labels. Ask if the user wants to override any string; defaults are fine.

### 5. Confirm domain layout

Single-context (`CONTEXT.md` + ADRs) or multi-context (`CONTEXT-MAP.md`). In the vault, the glossary lives at `<vault-dir>/Domain/CONTEXT.md` (multi-context: `<vault-dir>/Domain/CONTEXT-MAP.md` plus one `CONTEXT.md` per context under `Domain/`) and ADRs live at `<vault-dir>/ADRs`.

### 6. Write receipts + wire git

Do each applicable item below, then confirm all are done before moving on:

- `docs/agents/triage-labels.md` — copy `../setup-matt-pocock-skills/triage-labels.md`; note roles are applied as frontmatter `tags:`, not tracker labels.
- `docs/agents/domain.md` — copy `../setup-matt-pocock-skills/domain.md`, then rewrite its file-structure trees so the glossary sits under `<vault-dir>/Domain/` (`CONTEXT.md`, or `CONTEXT-MAP.md` + one `CONTEXT.md` per context — not the repo root) and ADRs sit in one `<vault-dir>/ADRs` dir (no per-context `src/<context>/docs/adr/`). Leave the consumer rules (glossary use, ADR-conflict flagging) unchanged.
- **If vault is tracker:** `docs/agents/issue-tracker.md` from [issue-tracker-vault.md](./issue-tracker-vault.md) — substitute every `{{VAULT_DIR}}` with the chosen vault dir name before writing.
- `## Agent skills` block in `CLAUDE.md`/`AGENTS.md` (see below). Same selection rules as `setup-matt-pocock-skills`: edit the file that exists; if neither, ask which to create; update an existing block in place.
- Ensure the project `.gitignore` ignores `<vault-dir>/.obsidian/workspace*` (create `.gitignore` if absent).
- Commit the vault into the repo (files only — `.git` already stripped).

Then, **if vault is tracker**, generate the project-local `/slice` skill (step 7).

The block:

```markdown
## Agent skills

### Issue tracker

[one-line: vault at `<vault-dir>/Projects/<slug>/`, or the fallback tracker]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line: roles applied as frontmatter tags]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line: single/multi-context, glossary at `<vault-dir>/Domain/CONTEXT.md`, ADRs at `<vault-dir>/ADRs`]. See `docs/agents/domain.md`.
```

### 7. Generate the `/slice` skill (only if vault is tracker)

Copy [slice-template.md](./slice-template.md) → `.claude/skills/slice/SKILL.md`. Fill every `{{...}}` placeholder from what step 1 found: `{{VAULT_DIR}}` (the chosen vault dir name), `{{PROJECT_NAME}}`, `{{PROJECT_SLUG}}`, build/test/lint commands, and module rules. This bakes the vault workflow + project specifics into one skill so fresh sessions don't re-learn it.

### 8. Done

Tell the user setup is complete. New PRDs/features get a project dir via `./new-project.sh <slug> <vault-dir>`. They can edit `docs/agents/*.md` and the vault dir directly; re-run only to switch trackers or restart.

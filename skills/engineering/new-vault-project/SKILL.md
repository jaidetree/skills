---
name: new-vault-project
description: Scaffold a vault project directory. Use when a skill (to-spec, to-tickets) needs to publish to the vault tracker and the project dir doesn't yet exist, or when the user asks to create a new vault project.
---

# New Vault Project

Scaffold `<vault-dir>/Projects/<slug>/` from the template using `new-project.sh`.

## Process

1. **Determine the slug** — use the argument if given; otherwise derive from the feature/spec name (kebab-case, lower-case, hyphens only). Confirm with the user if ambiguous.

2. **Determine the vault dir** — read `docs/agents/issue-tracker.md` and extract the `vault_dir:` frontmatter field. Fall back to `vault` if the file is absent or the field is missing.

3. **Check existence** — if `<vault-dir>/Projects/<slug>/` already exists, stop and report it.

4. **Locate the script** — it lives alongside the `setup-project-vault` skill:
   - `~/.claude/skills/setup-project-vault/new-project.sh`
   - `~/.agents/skills/setup-project-vault/new-project.sh` (fallback)

5. **Run**:
   ```
   bash <script-path> <slug> <vault-dir>
   ```

6. **Confirm** — `<vault-dir>/Projects/<slug>/` exists and `<vault-dir>/Projects/<slug>/<slug>.base` is present. Report the created path.

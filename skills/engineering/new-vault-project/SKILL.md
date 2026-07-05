---
name: new-vault-project
description: Scaffold a vault project directory. Use when a skill (to-prd, to-issues) needs to publish to the vault tracker and `vault/Projects/<slug>/` doesn't yet exist, or when the user asks to create a new vault project.
---

# New Vault Project

Scaffold `vault/Projects/<slug>/` from the template using `new-project.sh`.

## Process

1. **Determine the slug** — use the argument if given; otherwise derive from the feature/PRD name (kebab-case, lower-case, hyphens only). Confirm with the user if ambiguous.

2. **Check existence** — if `vault/Projects/<slug>/` already exists, stop and report it.

3. **Locate the script** — it lives alongside the `setup-project-vault` skill:
   - `~/.claude/skills/setup-project-vault/new-project.sh`
   - `~/.agents/skills/setup-project-vault/new-project.sh` (fallback)

4. **Run**:
   ```
   bash <script-path> <slug> vault
   ```

5. **Confirm** — `vault/Projects/<slug>/` exists and `vault/Projects/<slug>/<slug>.base` is present. Report the created path.

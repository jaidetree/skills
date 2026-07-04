#!/usr/bin/env bash
set -euo pipefail

# Instantiate a new project/feature dir in the vault from the bundled template.
# Copies Templates/Project/<project-name>/ -> Projects/<slug>/, renames the
# .base board, and repoints its columnRoot at the new path.
#
# Usage: ./new-project.sh <slug> [vault-dir]   (vault-dir defaults to "vault")
#
# NOTE: the template dir/base are literally named "<project-name>" (angle
# brackets). Every path is quoted so the shell never treats < > as redirects.

slug="${1:?usage: ./new-project.sh <slug> [vault-dir]}"
vault="${2:-vault}"

tpl="$vault/Templates/Project/<project-name>"
dest="$vault/Projects/$slug"

if [ ! -d "$tpl" ]; then
  echo "error: template not found: '$tpl' (is the vault cloned?)" >&2
  exit 1
fi
if [ -e "$dest" ]; then
  echo "error: project already exists: '$dest'" >&2
  exit 1
fi

cp -R "$tpl" "$dest"
mv "$dest/<project-name>.base" "$dest/$slug.base"

# Repoint the kanban columnRoot from the template path to this project.
sed -i.bak "s#Templates/Project/<project-name>/issues#Projects/$slug/issues#g" "$dest/$slug.base"
rm -f "$dest/$slug.base.bak"

echo "created '$dest' (board: $slug.base)"

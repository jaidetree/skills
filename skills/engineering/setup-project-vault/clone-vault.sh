#!/usr/bin/env bash
set -euo pipefail

# Clone the Obsidian project vault template into <dest> and strip its git
# history, so the vault files become plain files in the current repo.
#
# Usage: ./clone-vault.sh [dest]   (dest defaults to "vault")

REPO="https://github.com/jaidetree/obsidian-project-vault"
dest="${1:-vault}"

if [ -e "$dest" ]; then
  echo "error: '$dest' already exists — remove it or pass a different dest." >&2
  exit 1
fi

git clone --depth 1 "$REPO" "$dest"
rm -rf "$dest/.git"

echo "vault cloned to '$dest' (.git stripped)"

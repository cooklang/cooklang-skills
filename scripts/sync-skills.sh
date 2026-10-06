#!/usr/bin/env bash
# Copy skills/ from cook-md/cook-mcp (the canonical copy) into this repo.
#
# Usage:
#   scripts/sync-skills.sh [ref]
#
#   ref           git ref in cook-mcp: tag, branch or commit.
#                 Default: the latest cook-mcp release tag (needs `gh`).
#
# Environment:
#   COOK_MCP_DIR  use a local cook-mcp checkout instead of GitHub. With a ref,
#                 the skills are read from that ref (git archive); without one,
#                 from the checkout's working tree.
#   DEST          target directory (default: <repo>/skills). CI points this at
#                 a temp dir to compare against the committed copy.
#   COOK_MCP_REPO GitHub repo to fetch from (default: cook-md/cook-mcp).
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dest="${DEST:-$repo_root/skills}"
upstream="${COOK_MCP_REPO:-cook-md/cook-mcp}"
ref="${1:-}"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
src="$work/src"
mkdir -p "$src"

if [[ -n "${COOK_MCP_DIR:-}" ]]; then
  if [[ -n "$ref" ]]; then
    echo "sync-skills: $COOK_MCP_DIR @ $ref" >&2
    git -C "$COOK_MCP_DIR" archive "$ref" skills | tar -x -C "$src"
  else
    echo "sync-skills: $COOK_MCP_DIR (working tree)" >&2
    cp -R "$COOK_MCP_DIR/skills" "$src/skills"
  fi
else
  if [[ -z "$ref" ]]; then
    ref="$(gh release view -R "$upstream" --json tagName --jq .tagName)"
  fi
  echo "sync-skills: github.com/$upstream @ $ref" >&2
  git -C "$work" init -q clone
  git -C "$work/clone" remote add origin "https://github.com/$upstream.git"
  git -C "$work/clone" fetch -q --depth 1 origin "$ref"
  git -C "$work/clone" archive FETCH_HEAD skills | tar -x -C "$src"
fi

# Expect the plugin layout: skills/<name>/SKILL.md and nothing loose at the top.
loose="$(find "$src/skills" -mindepth 1 -maxdepth 1 -type f)"
if [[ -n "$loose" ]]; then
  echo "sync-skills: $ref has files directly under skills/ (old flat layout?):" >&2
  echo "$loose" >&2
  exit 1
fi
count=0
for dir in "$src/skills"/*/; do
  name="$(basename "$dir")"
  if [[ ! -f "$dir/SKILL.md" ]]; then
    echo "sync-skills: skills/$name has no SKILL.md" >&2
    exit 1
  fi
  count=$((count + 1))
done
if [[ "$count" -eq 0 ]]; then
  echo "sync-skills: no skills found at $ref" >&2
  exit 1
fi

rm -rf "$dest"
mkdir -p "$(dirname "$dest")"
cp -R "$src/skills" "$dest"
echo "sync-skills: wrote $count skills to $dest" >&2

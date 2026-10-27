#!/bin/sh
# Install the Flexoki Light theme into Herdr's config.toml.
#
# Usage:
#   ./install.sh
#   HERDR_CONFIG_PATH=/path/to/config.toml ./install.sh
#
# The theme is written as a managed block, so re-running upgrades it in place.
# The config file is backed up before any change.
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
THEME_FILE="$SCRIPT_DIR/flexoki.toml"
CONFIG="${HERDR_CONFIG_PATH:-${XDG_CONFIG_HOME:-$HOME/.config}/herdr/config.toml}"

BEGIN_MARKER="# >>> herdr-flexoki >>>"
END_MARKER="# <<< herdr-flexoki <<<"

if [ ! -f "$THEME_FILE" ]; then
  echo "error: $THEME_FILE not found" >&2
  exit 1
fi

mkdir -p -- "$(dirname -- "$CONFIG")"
touch -- "$CONFIG"

backup="$CONFIG.bak.$(date +%Y%m%d-%H%M%S)"
cp -- "$CONFIG" "$backup"

tmp=$(mktemp "${TMPDIR:-/tmp}/herdr-flexoki.XXXXXX")
trap 'rm -f -- "$tmp"' EXIT INT TERM

# Remove a previously managed block so re-running upgrades in place.
awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" '
  $0 == begin { skip = 1; next }
  $0 == end   { skip = 0; next }
  !skip
' "$CONFIG" > "$tmp"

# Refuse to create a second [theme] table.
if grep -Eq '^[[:space:]]*\[theme\][[:space:]]*$' "$tmp"; then
  echo "error: $CONFIG already defines a [theme] table outside the managed block." >&2
  echo "Remove that section (a backup is at $backup), then re-run." >&2
  rm -f -- "$tmp"
  exit 1
fi

{
  if [ -s "$tmp" ]; then printf '\n'; fi
  printf '%s\n' "$BEGIN_MARKER"
  cat -- "$THEME_FILE"
  printf '%s\n' "$END_MARKER"
} >> "$tmp"

cat -- "$tmp" > "$CONFIG"
rm -f -- "$tmp"

echo "Installed Flexoki Light into $CONFIG"
echo "Apply it with: herdr server reload-config   (or press prefix+shift+r in Herdr)"

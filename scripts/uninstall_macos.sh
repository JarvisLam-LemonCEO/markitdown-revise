#!/usr/bin/env bash
set -euo pipefail

INSTALL_ROOT="${MARKITDOWN_HOME:-$HOME/.local/share/markitdown-python314}"
STATE_DIR="$INSTALL_ROOT/state"
RC_FILE="$HOME/.zshrc"
BEGIN_MARKER="# >>> markitdown-python314 >>>"
END_MARKER="# <<< markitdown-python314 <<<"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok() { printf '\033[1;32mOK:\033[0m %s\n' "$*"; }

LAUNCHER=""
if [[ -f "$STATE_DIR/launcher-path" ]]; then
    LAUNCHER="$(cat "$STATE_DIR/launcher-path")"
fi

if [[ -n "$LAUNCHER" && -f "$LAUNCHER" ]] && grep -Fq "MARKITDOWN_PYTHON314_LAUNCHER" "$LAUNCHER"; then
    info "Removing global markitdown command..."
    rm -f "$LAUNCHER"
fi

if [[ -d "$INSTALL_ROOT" ]]; then
    info "Removing the private MarkItDown environment..."
    rm -rf "$INSTALL_ROOT"
fi

if [[ -f "$RC_FILE" ]] && grep -Fq "$BEGIN_MARKER" "$RC_FILE"; then
    info "Removing the PATH block added by the installer..."
    awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" '
        $0 == begin { skipping=1; next }
        $0 == end { skipping=0; next }
        !skipping { print }
    ' "$RC_FILE" > "$RC_FILE.tmp.markitdown"
    mv "$RC_FILE.tmp.markitdown" "$RC_FILE"
fi

ok "MarkItDown was removed. Python 3.14 itself was left installed."

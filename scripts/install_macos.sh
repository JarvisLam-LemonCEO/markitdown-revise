#!/usr/bin/env bash
set -euo pipefail

APP_NAME="MarkItDown Python 3.14"
INSTALL_ROOT="${MARKITDOWN_HOME:-$HOME/.local/share/markitdown-python314}"
VENV_DIR="$INSTALL_ROOT/venv"
STATE_DIR="$INSTALL_ROOT/state"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_DIR="$REPO_ROOT/packages/markitdown"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok() { printf '\033[1;32mOK:\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWARNING:\033[0m %s\n' "$*"; }
die() { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

if [[ "$(uname -s)" != "Darwin" ]]; then
    die "This installer is for macOS. Use the normal Python installation instructions on other operating systems."
fi

[[ -f "$PACKAGE_DIR/pyproject.toml" ]] || die "Could not find packages/markitdown/pyproject.toml. Run this installer from the complete repository."

python_is_314() {
    "$1" -c 'import sys; raise SystemExit(0 if sys.version_info[:2] == (3, 14) else 1)' >/dev/null 2>&1
}

find_python314() {
    local candidate

    if [[ -n "${MARKITDOWN_PYTHON:-}" ]]; then
        if [[ -x "$MARKITDOWN_PYTHON" ]] && python_is_314 "$MARKITDOWN_PYTHON"; then
            printf '%s\n' "$MARKITDOWN_PYTHON"
            return 0
        fi
        die "MARKITDOWN_PYTHON is set, but it is not a Python 3.14 interpreter: $MARKITDOWN_PYTHON"
    fi

    local brew_python=""
    if command -v brew >/dev/null 2>&1; then
        brew_python="$(brew --prefix python@3.14 2>/dev/null || true)/bin/python3.14"
    fi

    for candidate in \
        "$(command -v python3.14 2>/dev/null || true)" \
        "$brew_python" \
        "/opt/homebrew/bin/python3.14" \
        "/usr/local/bin/python3.14" \
        "/Library/Frameworks/Python.framework/Versions/3.14/bin/python3.14"; do
        if [[ -n "$candidate" && -x "$candidate" ]] && python_is_314 "$candidate"; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    if command -v python3 >/dev/null 2>&1 && python_is_314 "$(command -v python3)"; then
        command -v python3
        return 0
    fi

    return 1
}

install_python314_with_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        return 1
    fi

    info "Python 3.14 was not found. Installing python@3.14 with Homebrew..."
    brew install python@3.14
}

choose_launcher_dir() {
    local dir
    local old_ifs="$IFS"
    IFS=':'
    for dir in $PATH; do
        [[ -n "$dir" ]] || continue
        if [[ -d "$dir" && -w "$dir" ]]; then
            case "$dir" in
                "$HOME"/*|/opt/homebrew/bin|/usr/local/bin)
                    printf '%s\n' "$dir"
                    IFS="$old_ifs"
                    return 0
                    ;;
            esac
        fi
    done
    IFS="$old_ifs"

    printf '%s\n' "$HOME/.local/bin"
}

ensure_path() {
    local launcher_dir="$1"
    local rc_file="$HOME/.zshrc"
    local begin_marker="# >>> markitdown-python314 >>>"
    local end_marker="# <<< markitdown-python314 <<<"

    case ":$PATH:" in
        *":$launcher_dir:"*) return 0 ;;
    esac

    if [[ "$launcher_dir" != "$HOME/.local/bin" ]]; then
        warn "$launcher_dir is not currently on PATH."
        return 0
    fi

    mkdir -p "$launcher_dir"
    touch "$rc_file"

    if ! grep -Fq "$begin_marker" "$rc_file"; then
        info "Adding $launcher_dir to your zsh PATH..."
        {
            printf '\n%s\n' "$begin_marker"
            printf 'export PATH="$HOME/.local/bin:$PATH"\n'
            printf '%s\n' "$end_marker"
        } >> "$rc_file"
    fi
}

PYTHON314="$(find_python314 || true)"
if [[ -z "$PYTHON314" ]]; then
    if install_python314_with_homebrew; then
        PYTHON314="$(find_python314 || true)"
    fi
fi

if [[ -z "$PYTHON314" ]]; then
    die "Python 3.14 is required and was not found. Install Python 3.14 from python.org, then run Install MarkItDown.command again."
fi

ok "Using $($PYTHON314 --version 2>&1) at $PYTHON314"

info "Creating the private application environment..."
mkdir -p "$INSTALL_ROOT" "$STATE_DIR"
rm -rf "$VENV_DIR"
"$PYTHON314" -m venv "$VENV_DIR"

info "Updating Python packaging tools..."
"$VENV_DIR/bin/python" -m pip install --upgrade pip setuptools wheel

info "Installing MarkItDown and all optional converters..."
"$VENV_DIR/bin/python" -m pip install --upgrade "$PACKAGE_DIR[all]"

LAUNCHER_DIR="$(choose_launcher_dir)"
mkdir -p "$LAUNCHER_DIR"
LAUNCHER="$LAUNCHER_DIR/markitdown"

info "Installing the global markitdown command..."
cat > "$LAUNCHER" <<EOF_LAUNCHER
#!/bin/sh
# MARKITDOWN_PYTHON314_LAUNCHER
exec "$VENV_DIR/bin/python" -m markitdown "\$@"
EOF_LAUNCHER
chmod 755 "$LAUNCHER"
printf '%s\n' "$LAUNCHER" > "$STATE_DIR/launcher-path"
printf '%s\n' "$REPO_ROOT" > "$STATE_DIR/source-path"

ensure_path "$LAUNCHER_DIR"

info "Running a self-test..."
"$LAUNCHER" --help >/dev/null
ok "MarkItDown installed successfully."

printf '\n'
printf 'Global command: %s\n' "$LAUNCHER"
printf 'Private environment: %s\n' "$VENV_DIR"
printf '\nExamples:\n'
printf '  markitdown "$HOME/Downloads/file.pdf" -o "$HOME/Downloads/read.md"\n'
printf '  markitdown --help\n'
printf '\n'

case ":$PATH:" in
    *":$LAUNCHER_DIR:"*)
        printf 'The markitdown command is ready to use now.\n'
        ;;
    *)
        printf 'PATH was configured automatically. Open a new Terminal window once, then use markitdown from anywhere.\n'
        printf 'For this current Terminal only, you can also run: export PATH="%s:$PATH"\n' "$LAUNCHER_DIR"
        ;;
esac

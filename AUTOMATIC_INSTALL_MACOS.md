# Automatic macOS Installation

This modified MarkItDown build includes a macOS installer so users do not need to create or activate a Python virtual environment themselves.

## Install

From Finder, double-click:

```text
Install MarkItDown.command
```

Or from Terminal:

```bash
./"Install MarkItDown.command"
```

The installer creates and owns this private environment:

```text
~/.local/share/markitdown-python314/venv
```

It then installs the local modified MarkItDown package with all optional dependencies and creates a global `markitdown` command.

The source repository is **not** used as the runtime environment. This means moving the repository after installation does not break the installed command.

## Use

Example with a PDF in Downloads:

```bash
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

You can run this from any working directory.

For a filename containing spaces:

```bash
markitdown "$HOME/Downloads/My File.pdf" -o "$HOME/Downloads/My File.md"
```

## Update

Extract or clone the newer modified source tree, then run:

```bash
./"Install MarkItDown.command"
```

The installer recreates the managed environment and installs the version from that source tree.

## Uninstall

Double-click:

```text
Uninstall MarkItDown.command
```

or run:

```bash
./"Uninstall MarkItDown.command"
```

The uninstaller removes MarkItDown's managed environment and launcher. It leaves Python 3.14 installed.

## Installation locations

The managed environment defaults to:

```text
~/.local/share/markitdown-python314
```

The global launcher is installed into a writable directory already present on `PATH` when possible. If none is suitable, it uses:

```text
~/.local/bin/markitdown
```

and adds `~/.local/bin` to `~/.zshrc` automatically.

## Python 3.14

The installer searches for Python 3.14 in common macOS locations. If it cannot find Python 3.14 and Homebrew is installed, it runs:

```bash
brew install python@3.14
```

If neither Python 3.14 nor Homebrew is available, the installer stops with an explanatory message. Installing Python itself is intentionally kept separate from installing Homebrew.

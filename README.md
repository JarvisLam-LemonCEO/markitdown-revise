# MarkItDown for Python 3.14

A Python 3.14-compatible modification of [Microsoft MarkItDown](https://github.com/microsoft/markitdown), with a simplified macOS installer that makes the `markitdown` command available from any directory for the current user without requiring users to manually create or activate a virtual environment.

> [!IMPORTANT]
> This is an independent modification of the original Microsoft MarkItDown project. It is **not an official Microsoft release**. The original MarkItDown source, design, and core functionality are credited to Microsoft and its contributors.

## Credit and upstream project

This project is based on **MarkItDown**, originally developed and maintained by **Microsoft**.

- Original project: [github.com/microsoft/markitdown](https://github.com/microsoft/markitdown)
- Original copyright: Microsoft Corporation
- License: MIT License

The original Microsoft copyright and MIT license are preserved in [`LICENSE`](LICENSE).

Thank you to Microsoft and all upstream MarkItDown contributors for creating and maintaining the original project.

## About this modified version

The goal of this version is to keep MarkItDown working cleanly on **Python 3.14** and make installation easier for macOS users.

The MarkItDown conversion engine remains based on the upstream Microsoft project. This modification focuses primarily on Python 3.14 compatibility, dependency updates, packaging, Docker/CI support, and installation convenience.

## What we modified

### Python 3.14 compatibility

Python 3.14 support was added to the package metadata and project configuration.

The project continues to declare:

```text
Python >= 3.10
```

and now explicitly includes Python 3.14 in its package classifiers and test configuration.

### Updated Magika dependency

The original dependency constraint:

```text
magika~=0.6.1
```

was changed to:

```text
magika>=1.0.2,<2
```

This avoids compatibility problems with older Magika releases when installing under Python 3.14.

### Updated YouTube transcript dependency

The original dependency constraint:

```text
youtube-transcript-api~=1.0.0
```

was changed to:

```text
youtube-transcript-api>=1.2.3,<2
```

This allows the optional YouTube transcription feature to resolve correctly on Python 3.14.

### Python 3.14 CI support

The GitHub Actions Python test matrix was updated to cover:

```text
Python 3.10
Python 3.11
Python 3.12
Python 3.13
Python 3.14
```

### Docker updates

Relevant Docker configuration was updated to use Python 3.14, including:

```dockerfile
python:3.14-slim-bookworm
```

The MCP Docker build was also adjusted to install the patched local MarkItDown package when building from this repository.

### Automatic macOS installation

This modified version includes:

```text
Install MarkItDown.command
Uninstall MarkItDown.command
```

The installer automatically:

- finds Python 3.14;
- installs `python@3.14` with Homebrew when Python 3.14 is missing and Homebrew is already available;
- creates a private managed Python environment;
- installs this modified MarkItDown build with all optional dependencies;
- creates a global `markitdown` command for the current user;
- adds `~/.local/bin` to the user's zsh `PATH` when necessary; and
- tests the installation before finishing.

Users do **not** need to manually run:

```bash
python3.14 -m venv .venv
source .venv/bin/activate
```

The private application environment is managed automatically at:

```text
~/.local/share/markitdown-python314/venv
```

Because this is a normal installed copy rather than an editable project environment, moving or deleting the extracted source folder after installation does not break the installed `markitdown` command.

---

# Installation on macOS

## Option 1 — Finder

1. Download and extract this project.
2. Open the extracted folder.
3. Double-click:

```text
Install MarkItDown.command
```

4. Allow the installer to finish.
5. Open a new Terminal window if the installer tells you that the shell `PATH` was updated.
6. Test the command:

```bash
markitdown --help
```

That's it. You do not need to activate a virtual environment before using MarkItDown.

## Option 2 — Terminal

Open Terminal and go to the extracted project folder. For example:

```bash
cd ~/Downloads/markitdown-python314-global
```

Run:

```bash
./"Install MarkItDown.command"
```

Then test:

```bash
markitdown --help
```

If the installer added `~/.local/bin` to your `PATH`, open a new Terminal window once before running the command.

## Python 3.14 requirement

The installer looks for Python 3.14 automatically.

If Python 3.14 is not installed but Homebrew is already available, the installer attempts:

```bash
brew install python@3.14
```

If neither Python 3.14 nor Homebrew is available, install Python 3.14 first and run the installer again.

The installer does not install Homebrew itself.

---

# Using MarkItDown

## Convert a PDF

```bash
markitdown file.pdf -o read.md
```

## Convert a PDF stored in Downloads

The input file does **not** need to be in the same folder as MarkItDown.

Use its path:

```bash
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

You can run that command from any directory.

For example:

```bash
cd ~
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

## Files with spaces

Use quotes when a path contains spaces:

```bash
markitdown "$HOME/Downloads/My File.pdf" -o "$HOME/Downloads/My File.md"
```

## Save output somewhere else

For example, read a PDF from Downloads and save Markdown to Documents:

```bash
markitdown ~/Downloads/report.pdf -o ~/Documents/report.md
```

## Print output directly to Terminal

```bash
markitdown ~/Downloads/file.pdf
```

## Show command help

```bash
markitdown --help
```

---

# Supported conversions

MarkItDown supports many common formats, depending on installed optional dependencies, including:

- PDF
- Microsoft Word documents
- Microsoft PowerPoint presentations
- Microsoft Excel spreadsheets
- HTML
- CSV
- JSON
- XML
- images
- audio
- ZIP archives
- EPUB
- YouTube URLs/transcripts
- and other formats supported by the upstream project

This installer installs the local package with:

```text
[all]
```

so the complete optional dependency set defined by this version is installed.

---

# Updating this modified version

To update MarkItDown after downloading a newer copy of this modified project:

1. Extract the newer project version.
2. Run:

```text
Install MarkItDown.command
```

again.

Or from Terminal:

```bash
./"Install MarkItDown.command"
```

The installer recreates the managed environment and installs the package from the current source tree.

There is no need to manually remove the previous environment first.

---

# Uninstall

Double-click:

```text
Uninstall MarkItDown.command
```

or run:

```bash
./"Uninstall MarkItDown.command"
```

The uninstaller removes:

- the managed MarkItDown Python environment;
- the global `markitdown` launcher created by this installer; and
- the `PATH` block added by this installer, if applicable.

It does **not** remove Python 3.14 itself.

---

# Installation locations

The automatic installer uses:

```text
~/.local/share/markitdown-python314/
```

for the managed application environment.

The command launcher is placed in a writable directory already on `PATH` when possible. Otherwise it uses:

```text
~/.local/bin/markitdown
```

and configures `~/.local/bin` in `~/.zshrc` automatically.

You can check which command is being used with:

```bash
which markitdown
```

---

# Developer installation

The automatic installer is recommended for normal use.

If you are modifying the source code and intentionally want an editable development installation, you can still create a development environment manually:

```bash
python3.14 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
python -m pip install -e './packages/markitdown[all]'
```

Then run:

```bash
markitdown --help
```

An editable environment contains paths back to the source repository. If you move the repository, recreate that development environment from the new location.

This limitation does **not** apply to the automatic macOS installation described above.

---

# Additional documentation

For installer-specific details, see:

- [`AUTOMATIC_INSTALL_MACOS.md`](AUTOMATIC_INSTALL_MACOS.md)
- [`PYTHON_3_14.md`](PYTHON_3_14.md)

---

# Security

MarkItDown processes files and other resources with the permissions of the user/process running it. Do not process untrusted files or URLs in environments where access to sensitive resources would be unsafe.

For upstream and repository security information, see [`SECURITY.md`](SECURITY.md).

---

# License and attribution

This modified project remains distributed under the **MIT License** included in [`LICENSE`](LICENSE).

The original MarkItDown project is copyright Microsoft Corporation and is available at:

[https://github.com/microsoft/markitdown](https://github.com/microsoft/markitdown)

This repository contains modifications made for Python 3.14 compatibility and installation convenience. Those modifications do not imply endorsement by, affiliation with, or official support from Microsoft.

When redistributing this project, preserve the included MIT license and Microsoft copyright notice as required by the license.

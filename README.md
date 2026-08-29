# MarkItDown for Python 3.14 (with macOS/Windows installer automatically)

A Python 3.14-compatible modification of [Microsoft MarkItDown](https://github.com/microsoft/markitdown), with simplified **macOS and Windows installers** that make the `markitdown` command available from any directory without requiring users to manually create or activate a virtual environment.

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

The goal of this version is to keep MarkItDown working cleanly on **Python 3.14** and make installation easier for both **macOS and Windows users**.

The MarkItDown conversion engine remains based on the upstream Microsoft project. This modification focuses primarily on Python 3.14 compatibility, dependency updates, packaging, Docker/CI support, and installation convenience.

## What we modified

### Python 3.14 compatibility

Python 3.14 support was added to the package metadata and project configuration.

The project continues to declare:

```text
Python >= 3.10
```

and now explicitly includes Python 3.14 in package classifiers and test configuration.

### Updated Magika dependency

Original constraint:

```text
magika~=0.6.1
```

Updated constraint:

```text
magika>=1.0.2,<2
```

This avoids compatibility problems with older Magika releases on Python 3.14.

### Updated YouTube transcript dependency

Original constraint:

```text
youtube-transcript-api~=1.0.0
```

Updated constraint:

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

Included files:

```text
Install MarkItDown.command
Uninstall MarkItDown.command
```

The macOS installer automatically:

- finds Python 3.14;
- installs `python@3.14` with Homebrew when Python 3.14 is missing and Homebrew is already available;
- creates a private managed Python environment;
- installs this modified MarkItDown build with all optional dependencies;
- creates a global `markitdown` command for the current user;
- configures the user's `PATH` when necessary; and
- tests the installation before finishing.

### Automatic Windows installation

Included files:

```text
Install MarkItDown Windows.cmd
Uninstall MarkItDown Windows.cmd
```

The Windows installer automatically:

- finds a Python 3.14 installation;
- attempts to install Python 3.14 with WinGet if it is missing;
- creates a private managed Python environment under `%LOCALAPPDATA%`;
- installs this modified MarkItDown build with all optional dependencies;
- creates a per-user global `markitdown` command;
- adds the launcher directory to the user's `PATH`; and
- runs `markitdown --help` as a self-test.

Users on either platform do **not** need to manually create or activate a virtual environment.

---

# Installation

## macOS

### Option 1 — Finder

1. Download and extract this project.
2. Open the extracted folder.
3. Double-click:

```text
Install MarkItDown.command
```

4. Allow the installer to finish.
5. If requested, open a new Terminal window so the updated `PATH` is loaded.
6. Test:

```bash
markitdown --help
```

No manual virtual-environment activation is required.

### Option 2 — Terminal

Open Terminal and enter the extracted project folder, for example:

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

### macOS Python requirement

The installer looks for Python 3.14 automatically.

If Python 3.14 is not installed but Homebrew is already available, it attempts:

```bash
brew install python@3.14
```

If neither Python 3.14 nor Homebrew is available, install Python 3.14 first and run the installer again.

The installer does not install Homebrew itself.

---

## Windows

### Option 1 — File Explorer

1. Download and extract this project.
2. Open the extracted folder.
3. Double-click:

```text
Install MarkItDown Windows.cmd
```

4. If Windows shows a security warning, review the source and allow it to run if you trust this project.
5. Allow installation to finish.
6. Open a **new** Command Prompt or PowerShell window.
7. Test:

```powershell
markitdown --help
```

No manual virtual-environment activation is required.

### Option 2 — Command Prompt

Enter the extracted project directory. Example:

```cmd
cd %USERPROFILE%\Downloads\markitdown-python314-global
```

Run:

```cmd
"Install MarkItDown Windows.cmd"
```

Open a new Command Prompt and test:

```cmd
markitdown --help
```

### Option 3 — PowerShell

```powershell
cd "$HOME\Downloads\markitdown-python314-global"
& ".\Install MarkItDown Windows.cmd"
```

Then open a new PowerShell window and run:

```powershell
markitdown --help
```

### Windows Python requirement

The installer looks for Python 3.14 automatically using common Python commands and installation locations.

If Python 3.14 is missing and **WinGet** is available, it attempts to install:

```text
Python.Python.3.14
```

for the current user.

If automatic installation is unavailable, install Python 3.14 and run the installer again.

---

# Where the automatic installers put MarkItDown

## macOS

Managed Python environment:

```text
~/.local/share/markitdown-python314/venv
```

The `markitdown` launcher is placed in a writable directory already on `PATH` when possible. Otherwise the installer uses:

```text
~/.local/bin/markitdown
```

and configures `~/.local/bin` in `~/.zshrc`.

Check the launcher with:

```bash
which markitdown
```

## Windows

Managed Python environment:

```text
%LOCALAPPDATA%\MarkItDown-Python314\venv
```

Global user launcher:

```text
%LOCALAPPDATA%\Programs\MarkItDown\bin\markitdown.cmd
```

That launcher directory is automatically added to the current user's `PATH`.

Check the launcher in Command Prompt:

```cmd
where markitdown
```

Or PowerShell:

```powershell
Get-Command markitdown
```

## Why moving the source folder no longer breaks MarkItDown

The automatic installers perform a normal installation into a dedicated managed environment instead of using editable mode.

That means after installation you can move or delete the extracted source directory and the installed `markitdown` command will continue to work.

---

# Using MarkItDown

# Supported file format
## PDF
markitdown document.pdf -o document.md

## PowerPoint
markitdown presentation.pptx -o presentation.md

## Word
markitdown document.docx -o document.md

## Excel (.xlsx)
markitdown workbook.xlsx -o workbook.md

## Older Excel (.xls)
markitdown workbook.xls -o workbook.md

## Image
markitdown image.jpg -o image.md

## PNG image
markitdown image.png -o image.md

## Audio - MP3
markitdown audio.mp3 -o audio.md

## Audio - WAV
markitdown audio.wav -o audio.md

## HTML
markitdown page.html -o page.md

## CSV
markitdown data.csv -o data.md

## JSON
markitdown data.json -o data.md

## XML
markitdown data.xml -o data.md

## ZIP
markitdown archive.zip -o archive.md

## YouTube
markitdown "https://www.youtube.com/watch?v=VIDEO_ID" -o video.md

## EPUB
markitdown book.epub -o book.md

## Convert a PDF in the current folder

```bash
markitdown file.pdf -o read.md
```

## macOS — PDF stored in Downloads

```bash
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

You can run that from any directory:

```bash
cd ~
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

### macOS filenames with spaces

```bash
markitdown "$HOME/Downloads/My File.pdf" -o "$HOME/Downloads/My File.md"
```

## Windows — PDF stored in Downloads

### PowerShell

```powershell
markitdown "$HOME\Downloads\file.pdf" -o "$HOME\Downloads\read.md"
```

### Command Prompt

```cmd
markitdown "%USERPROFILE%\Downloads\file.pdf" -o "%USERPROFILE%\Downloads\read.md"
```

### Windows filenames with spaces

PowerShell:

```powershell
markitdown "$HOME\Downloads\My File.pdf" -o "$HOME\Downloads\My File.md"
```

Command Prompt:

```cmd
markitdown "%USERPROFILE%\Downloads\My File.pdf" -o "%USERPROFILE%\Downloads\My File.md"
```

## Save output somewhere else

macOS:

```bash
markitdown ~/Downloads/report.pdf -o ~/Documents/report.md
```

Windows PowerShell:

```powershell
markitdown "$HOME\Downloads\report.pdf" -o "$HOME\Documents\report.md"
```

## Print output directly to the terminal

```bash
markitdown file.pdf
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

The automatic installers install the local package with the `[all]` optional dependency set.

---

# Updating this modified version

Download and extract the newer version of this modified project, then run the installer again.

## macOS

```text
Install MarkItDown.command
```

or:

```bash
./"Install MarkItDown.command"
```

## Windows

```text
Install MarkItDown Windows.cmd
```

The installer rebuilds the private managed environment and installs the package from the current source tree.

You do not need to manually remove the previous environment first.

---

# Uninstall

## macOS

Double-click:

```text
Uninstall MarkItDown.command
```

or run:

```bash
./"Uninstall MarkItDown.command"
```

## Windows

Double-click:

```text
Uninstall MarkItDown Windows.cmd
```

The uninstallers remove the private MarkItDown environment and launcher created by this modified project.

They **do not remove Python 3.14 itself**.

---

# Developer installation

The automatic installers are recommended for normal use.

If you are modifying the source code and intentionally want an editable development installation, use a development environment.

## macOS / Linux development

```bash
python3.14 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
python -m pip install -e './packages/markitdown[all]'
```

## Windows PowerShell development

```powershell
py -3.14 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip setuptools wheel
python -m pip install -e ".\packages\markitdown[all]"
```

An editable environment contains paths back to the source repository. If you move the repository, recreate that development environment from the new location.

This limitation does **not** apply to the automatic macOS or Windows installations.

---

# Additional documentation

- [`AUTOMATIC_INSTALL_MACOS.md`](AUTOMATIC_INSTALL_MACOS.md)
- [`AUTOMATIC_INSTALL_WINDOWS.md`](AUTOMATIC_INSTALL_WINDOWS.md)
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

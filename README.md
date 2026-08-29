# MarkItDown — Python 3.14 Compatibility Modification

This repository is a modified version of **MarkItDown** with updates intended to improve compatibility with **Python 3.14**.

It also includes updated installation guidance for running MarkItDown from any folder, using files stored in other locations, and fixing a virtual environment after moving the project directory.

---

## What Was Modified

### Python 3.14 support

Python 3.14 was added to the supported/tested Python versions.

Supported versions include:

```text
Python 3.10
Python 3.11
Python 3.12
Python 3.13
Python 3.14
```

Python 3.14 is the primary target of this modified version.

---

## Dependency Updates

### Magika

Original:

```text
magika~=0.6.1
```

Updated:

```text
magika>=1.0.2,<2
```

### youtube-transcript-api

Original:

```text
youtube-transcript-api~=1.0.0
```

Updated:

```text
youtube-transcript-api>=1.2.3,<2
```

These dependency changes are intended to avoid Python 3.14 compatibility problems found with older releases.

---

## Docker Changes

Relevant Docker configuration was updated to use Python 3.14.

Example base image:

```dockerfile
python:3.14-slim-bookworm
```

The MCP Docker installation path was also adjusted so that it installs the modified local MarkItDown source rather than unintentionally using an older package version.

---

## CI / GitHub Actions

The Python test matrix includes:

```text
3.10
3.11
3.12
3.13
3.14
```

---

# Installation

## Requirements

You need:

- Python 3.14
- pip
- Git if cloning the repository
- A virtual environment is recommended for development

Check Python:

```bash
python3.14 --version
```

Expected:

```text
Python 3.14.x
```

---

# macOS / Linux Installation

Go to the MarkItDown project folder.

Example:

```bash
cd ~/Projects/markitdown-python314
```

Create a Python 3.14 virtual environment:

```bash
python3.14 -m venv .venv
```

Activate it:

```bash
source .venv/bin/activate
```

Upgrade packaging tools:

```bash
python -m pip install --upgrade pip setuptools wheel
```

Install MarkItDown with all optional features:

```bash
pip install -e "./packages/markitdown[all]"
```

Test:

```bash
markitdown --help
```

If the help menu appears, MarkItDown is installed correctly.

---

# Windows Installation

Open PowerShell inside the project directory.

Example:

```powershell
cd C:\Users\YOURNAME\Projects\markitdown-python314
```

Check Python:

```powershell
py -3.14 --version
```

Create a virtual environment:

```powershell
py -3.14 -m venv .venv
```

Activate it:

```powershell
.\.venv\Scripts\Activate.ps1
```

Upgrade packaging tools:

```powershell
python -m pip install --upgrade pip setuptools wheel
```

Install MarkItDown:

```powershell
pip install -e ".\packages\markitdown[all]"
```

Test:

```powershell
markitdown --help
```

---

# Important: Moving the MarkItDown Folder

If you installed MarkItDown with:

```bash
pip install -e "./packages/markitdown[all]"
```

then it is installed in **editable mode**.

A Python virtual environment also stores paths related to the location where it was created.

If you create `.venv` while the project is in:

```text
~/Downloads/markitdown-python314
```

and later move the project to:

```text
~/Projects/markitdown-python314
```

the old virtual environment may no longer work correctly.

You may see:

```text
(.venv) user@Mac ~ % markitdown --help

zsh: command not found: markitdown
```

Even though `(.venv)` appears in the Terminal prompt, the environment can still be broken because the project was moved.

---

# Fix After Moving the Project

## macOS / Linux

### 1. Exit the old environment

```bash
deactivate
```

### 2. Go to the new project location

Example:

```bash
cd ~/Projects/markitdown-python314
```

Use the actual folder where you moved the project.

### 3. Delete the old virtual environment

```bash
rm -rf .venv
```

### 4. Create a new Python 3.14 environment

```bash
python3.14 -m venv .venv
```

### 5. Activate it

```bash
source .venv/bin/activate
```

### 6. Upgrade pip and build tools

```bash
python -m pip install --upgrade pip setuptools wheel
```

### 7. Reinstall MarkItDown

```bash
pip install -e "./packages/markitdown[all]"
```

### 8. Test MarkItDown

```bash
markitdown --help
```

### 9. Confirm which executable is being used

```bash
which markitdown
```

Example:

```text
/Users/YOURNAME/Projects/markitdown-python314/.venv/bin/markitdown
```

If the path points to the new project location, the environment is fixed.

---

# Quick Repair Commands After Moving the Project

If your new project location is:

```text
~/Projects/markitdown-python314
```

you can run:

```bash
deactivate 2>/dev/null || true

cd ~/Projects/markitdown-python314

rm -rf .venv

python3.14 -m venv .venv
source .venv/bin/activate

python -m pip install --upgrade pip setuptools wheel

pip install -e "./packages/markitdown[all]"

markitdown --help
```

---

# Using MarkItDown With Files in Other Folders

MarkItDown and your PDF **do not need to be in the same directory**.

Suppose:

```text
MarkItDown project:
~/Projects/markitdown-python314

PDF:
~/Downloads/file.pdf
```

You can run:

```bash
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

This converts:

```text
~/Downloads/file.pdf
```

to:

```text
~/Downloads/read.md
```

The current Terminal directory does not need to contain the PDF.

---

# Why `markitdown file.pdf` Sometimes Fails

If you run:

```bash
markitdown file.pdf -o read.md
```

the shell looks for:

```text
file.pdf
```

inside your **current Terminal directory**.

For example, if your prompt shows:

```text
user@Mac ~ %
```

your current directory is normally:

```text
~
```

If the PDF is actually in Downloads, this command:

```bash
markitdown file.pdf -o read.md
```

will not find it.

Use:

```bash
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

instead.

---

# Files With Spaces in Their Names

Use quotes around paths containing spaces.

Example:

```bash
markitdown "$HOME/Downloads/My File.pdf" -o "$HOME/Downloads/My File.md"
```

You can also use a complete absolute path:

```bash
markitdown "/Users/YOURNAME/Downloads/My File.pdf" -o "/Users/YOURNAME/Downloads/My File.md"
```

---

# Save the Output Somewhere Else

Input in Downloads:

```text
~/Downloads/file.pdf
```

Output in Documents:

```bash
markitdown ~/Downloads/file.pdf -o ~/Documents/read.md
```

Input and output locations can be completely different.

---

# Use MarkItDown From Any Directory

After activating the correct virtual environment:

```bash
cd ~/Projects/markitdown-python314
source .venv/bin/activate
```

you can change to another directory:

```bash
cd ~
```

and MarkItDown should still work:

```bash
markitdown --help
```

Then convert a PDF in Downloads:

```bash
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

The important part is that the correct `.venv` must still be active.

---

# Opening a New Terminal Window

When using the project virtual environment, every new Terminal session normally requires activation again.

Run:

```bash
cd ~/Projects/markitdown-python314
source .venv/bin/activate
```

Then:

```bash
markitdown --help
```

After activation, you can move to any folder:

```bash
cd ~
```

and continue using:

```bash
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

---

# Recommended Permanent Command-Line Installation

If you use MarkItDown regularly and do not want to activate `.venv` every time, install the modified project as a command-line tool using `uv`.

This is generally more convenient for normal daily use.

## Install `uv`

If `uv` is already installed, skip this section.

Check:

```bash
uv --version
```

If the command exists, continue below.

---

## Install the Modified MarkItDown With `uv`

Go to the project:

```bash
cd ~/Projects/markitdown-python314
```

Install the local modified package using Python 3.14:

```bash
uv tool install --python 3.14 "./packages/markitdown[all]"
```

Then update your shell PATH if necessary:

```bash
uv tool update-shell
```

Close and reopen Terminal.

Test:

```bash
markitdown --help
```

Now you should normally be able to use MarkItDown without activating the project `.venv`.

Example:

```bash
cd ~
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

---

# Development Installation vs Permanent Installation

## Development / Editable Installation

Use:

```bash
pip install -e "./packages/markitdown[all]"
```

Recommended when modifying MarkItDown source code.

Advantages:

- Changes to the source are available immediately.
- Good for development and testing.

Important:

- The virtual environment must normally be activated.
- Moving the repository can break the environment.
- If you move the repository, recreate `.venv` and reinstall the package.

---

## Permanent CLI Installation With `uv`

Use:

```bash
uv tool install --python 3.14 "./packages/markitdown[all]"
```

Recommended for regular command-line use.

Advantages:

- `markitdown` can be used from different directories.
- You do not normally need to activate the project's `.venv`.
- Your PDFs can remain anywhere, such as Downloads.

---

# Basic Usage

Print converted Markdown to the Terminal:

```bash
markitdown file.pdf
```

Save the output:

```bash
markitdown file.pdf -o file.md
```

Convert a file from Downloads:

```bash
markitdown ~/Downloads/file.pdf -o ~/Downloads/file.md
```

---

# Recommended Folder Layout

A clean setup could look like:

```text
~/Projects/
└── markitdown-python314/
    ├── packages/
    ├── README.md
    └── .venv/

~/Downloads/
├── document.pdf
└── document.md
```

Then run:

```bash
markitdown ~/Downloads/document.pdf -o ~/Downloads/document.md
```

The PDF does not need to be copied into the MarkItDown project directory.

---

# Verify the Installation

Check Python:

```bash
python --version
```

Expected while using the Python 3.14 environment:

```text
Python 3.14.x
```

Check MarkItDown:

```bash
markitdown --help
```

Find the executable:

```bash
which markitdown
```

For a project virtual environment, it may look like:

```text
/Users/YOURNAME/Projects/markitdown-python314/.venv/bin/markitdown
```

---

# Troubleshooting

## `zsh: command not found: markitdown`

If the project was moved after creating `.venv`, rebuild the environment.

```bash
deactivate
cd ~/Projects/markitdown-python314
rm -rf .venv
python3.14 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
pip install -e "./packages/markitdown[all]"
markitdown --help
```

---

## Terminal shows `(.venv)` but MarkItDown is missing

Example:

```text
(.venv) user@Mac ~ % markitdown --help
zsh: command not found: markitdown
```

The virtual environment may have been created before the project was moved.

Do not rely only on `(.venv)` appearing in the prompt.

Check:

```bash
which python
```

and:

```bash
which markitdown
```

If MarkItDown is missing or paths point to the old location, recreate `.venv`.

---

## `file.pdf` cannot be found

If the file is located in Downloads, use its path:

```bash
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

Do not use only:

```bash
markitdown file.pdf -o read.md
```

unless `file.pdf` is actually in your current working directory.

---

## Check the current directory

Run:

```bash
pwd
```

Example:

```text
/Users/YOURNAME
```

List files:

```bash
ls
```

Check Downloads:

```bash
ls ~/Downloads
```

---

## Confirm MarkItDown Is Installed

Inside the activated environment:

```bash
pip show markitdown
```

Or:

```bash
pip list | grep markitdown
```

---

# macOS Recommended Setup

For development:

```bash
cd ~/Projects/markitdown-python314

python3.14 -m venv .venv
source .venv/bin/activate

python -m pip install --upgrade pip setuptools wheel

pip install -e "./packages/markitdown[all]"

markitdown --help
```

For regular daily use, consider:

```bash
cd ~/Projects/markitdown-python314

uv tool install --python 3.14 "./packages/markitdown[all]"

uv tool update-shell
```

Then reopen Terminal and test:

```bash
markitdown --help
```

---

# Example Workflow

Project:

```text
~/Projects/markitdown-python314
```

Input:

```text
~/Downloads/file.pdf
```

Output:

```text
~/Downloads/read.md
```

With the virtual environment:

```bash
cd ~/Projects/markitdown-python314
source .venv/bin/activate

markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

Or, after installing through `uv tool`:

```bash
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

---

---

# Credits and Attribution

This project is based on **MarkItDown**, the open-source project developed by **Microsoft Corporation**.

Original project:

**Microsoft MarkItDown**  
https://github.com/microsoft/markitdown

The original MarkItDown project is licensed under the **MIT License**.

This repository contains modifications intended to improve compatibility with **Python 3.14**, including dependency updates, Docker configuration changes, CI updates, installation guidance, and virtual-environment troubleshooting.

These modifications are independently maintained and are **not an official Microsoft release**. Microsoft does not endorse or maintain this modified version unless otherwise stated by Microsoft.

## License

The original Microsoft copyright notice and MIT License should be retained in accordance with the terms of the MIT License.

Copyright (c) Microsoft Corporation.

See the project's `LICENSE` file for the complete license text.

When redistributing this modified version, keep the original `LICENSE` file and copyright notice with the project.


# Summary

This modified MarkItDown version includes:

- Python 3.14 compatibility updates
- Updated Magika dependency
- Updated youtube-transcript-api dependency
- Python 3.14 Docker configuration
- Python 3.14 CI testing
- Updated local package installation behavior
- Instructions for files stored outside the project directory
- Instructions for fixing `.venv` after moving the project
- A recommended `uv tool` installation for convenient command-line use

## Most Important Commands

If you moved the project and MarkItDown stopped working:

```bash
deactivate
cd ~/Projects/markitdown-python314
rm -rf .venv
python3.14 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
pip install -e "./packages/markitdown[all]"
markitdown --help
```

To convert a PDF stored in Downloads:

```bash
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

For a convenient permanent command:

```bash
uv tool install --python 3.14 "./packages/markitdown[all]"
uv tool update-shell
```

Then:

```bash
markitdown ~/Downloads/file.pdf -o ~/Downloads/read.md
```

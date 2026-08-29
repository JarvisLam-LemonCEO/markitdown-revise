# Automatic Windows Installation

This modified MarkItDown distribution includes a Windows installer that manages Python isolation automatically. Users do not need to create, activate, or understand a virtual environment.

## Install

1. Download and extract the complete project.
2. Double-click `Install MarkItDown Windows.cmd`.
3. If Windows displays a security prompt, review the file/source and allow it to run if you trust this project.
4. The installer looks for Python 3.14.
5. If Python 3.14 is missing and WinGet is available, the installer attempts to install `Python.Python.3.14` for the current user.
6. When installation finishes, open a new Command Prompt or PowerShell window.
7. Test:

```powershell
markitdown --help
```

## Where it installs

The private managed Python environment is stored under:

```text
%LOCALAPPDATA%\MarkItDown-Python314\venv
```

The global launcher is stored under:

```text
%LOCALAPPDATA%\Programs\MarkItDown\bin\markitdown.cmd
```

The installer adds the launcher directory to the current user's `PATH` automatically.

Because MarkItDown is installed normally into the private environment rather than in editable mode, the extracted source directory can be moved or deleted after installation without breaking the `markitdown` command.

## Usage

Convert a PDF in Downloads:

```powershell
markitdown "$HOME\Downloads\file.pdf" -o "$HOME\Downloads\read.md"
```

Command Prompt equivalent:

```cmd
markitdown "%USERPROFILE%\Downloads\file.pdf" -o "%USERPROFILE%\Downloads\read.md"
```

The source PDF and MarkItDown project do not need to be in the same folder.

## Update

Download/extract the newer source and run `Install MarkItDown Windows.cmd` again. The managed environment is rebuilt from the current source tree.

## Uninstall

Double-click:

```text
Uninstall MarkItDown Windows.cmd
```

The uninstaller removes the managed environment, launcher, and PATH entry created by this project. It leaves Python 3.14 installed.

## Advanced override

If Python 3.14 exists in a custom location, set `MARKITDOWN_PYTHON` to the full path of `python.exe` before running the installer.

Example:

```powershell
$env:MARKITDOWN_PYTHON = "D:\Python314\python.exe"
& ".\Install MarkItDown Windows.cmd"
```

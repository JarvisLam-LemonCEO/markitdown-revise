# Python 3.14 compatibility

This repository has been updated to support the current stable Python 3.14 series.

## What changed

- Added Python 3.14 package classifiers to all Python packages in this repository.
- Updated Magika from `magika~=0.6.1` to `magika>=1.0.2,<2`. Magika 1.0.2 is the first release line that explicitly supports Python 3.14 and removes the old ONNX Runtime constraint that blocked 3.14.
- Updated the `all` / YouTube dependency from `youtube-transcript-api~=1.0.0` to `youtube-transcript-api>=1.2.3,<2`. Versions through 1.2.2 declare `python_requires <3.14`, which prevents `markitdown[all]` from resolving on Python 3.14.
- Updated CI to test Python 3.10 through 3.14 using a version matrix.
- Updated the root and MCP Docker images to `python:3.14-slim-bookworm`; the MCP image now installs the patched local core package when built from the repository root.
- Updated README virtual-environment examples to use Python 3.14.

## Python 3.14 setup

Using `uv`:

```bash
uv venv --python=3.14 .venv
source .venv/bin/activate
uv pip install -e 'packages/markitdown[all]'
```

Using standard Python:

```bash
python3.14 -m venv .venv
source .venv/bin/activate
python -m pip install -U pip
python -m pip install -e 'packages/markitdown[all]'
```

Run the test suite with:

```bash
cd packages/markitdown
python -m pytest
```

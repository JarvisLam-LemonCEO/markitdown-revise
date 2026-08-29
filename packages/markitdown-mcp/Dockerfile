FROM python:3.14-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV EXIFTOOL_PATH=/usr/bin/exiftool
ENV FFMPEG_PATH=/usr/bin/ffmpeg
ENV MARKITDOWN_ENABLE_PLUGINS=True

# Runtime dependency
# NOTE: Add any additional MarkItDown plugins here
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    exiftool \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Build this Dockerfile from the repository root so the MCP server uses the
# local, Python-3.14-compatible MarkItDown package instead of the PyPI release.
COPY packages/markitdown /app/packages/markitdown
COPY packages/markitdown-mcp /app/packages/markitdown-mcp
RUN pip --no-cache-dir install \
    '/app/packages/markitdown[all]' \
    /app/packages/markitdown-mcp

WORKDIR /workdir

# Default USERID and GROUPID
ARG USERID=nobody
ARG GROUPID=nogroup

USER $USERID:$GROUPID

ENTRYPOINT [ "markitdown-mcp" ]

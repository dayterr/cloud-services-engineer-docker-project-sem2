#!/bin/sh
set -e

if [ -n "$JWT_TOKEN" ]; then
    echo "JWT_TOKEN provided via environment variable."
else
    if [ -n "$JWT_TOKEN_FILE" ] && [ -f "$JWT_TOKEN_FILE" ]; then
        export JWT_TOKEN=$(cat "$JWT_TOKEN_FILE")
        echo "JWT_TOKEN loaded from Docker secret file."
    else
        echo "WARNING: JWT_TOKEN is not found! Authentication will fail." >&2
    fi
fi

exec "$@"
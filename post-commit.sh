#!/bin/bash

# Define source and destination directories
SRC_DIR="$HOME/.config/nvim"
DST_DIR="$(git rev-parse --show-toplevel)/nvim/lazy"

# Copy the files
cp "$SRC_DIR/lazy-lock.json" "$DST_DIR/lazy-lock.json"
cp "$SRC_DIR/lazyvim.json" "$DST_DIR/lazyvim.json"

# Check if there are changes to commit
if git diff --quiet "$DST_DIR"; then
    echo "No changes to sync."
else
    git commit "$DST_DIR" -m "sync lazy"
fi

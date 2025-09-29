#!/bin/bash
# Configure git to show word-level diffs for keymap files

# Set up custom diff driver for .keymap files
git config diff.keymap.wordRegex '&[a-zA-Z0-9_]+|[a-zA-Z0-9_]+|[^[:space:]]'

# Create helpful aliases
git config alias.kdiff "diff --word-diff=color --word-diff-regex='&[a-zA-Z0-9_]+|[a-zA-Z0-9_]+|[^[:space:]]'"

echo "Git configured for better keymap diffs."
echo "Usage:"
echo "  git diff                 # Will now show word-level for .keymap files"
echo "  git kdiff <file>         # Force word-level diff for any file"

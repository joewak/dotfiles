#!/bin/bash
# Bootstrap script for dotfiles setup

set -e

echo "Setting up dotfiles..."

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create .claude directory if it doesn't exist
mkdir -p ~/.claude

# Check if commands directory exists and is a symlink
if [ -L ~/.claude/commands ]; then
    echo "✓ Symlink already exists at ~/.claude/commands"
elif [ -d ~/.claude/commands ]; then
    echo "⚠ Warning: ~/.claude/commands exists but is not a symlink"
    echo "  Please backup and remove it manually, then run this script again"
    exit 1
else
    # Create the symlink
    ln -s "$DOTFILES_DIR/.claude/commands" ~/.claude/commands
    echo "✓ Created symlink: ~/.claude/commands -> $DOTFILES_DIR/.claude/commands"
fi

# Verify the setup
if [ -L ~/.claude/commands ] && [ -d ~/.claude/commands ]; then
    echo ""
    echo "✅ Dotfiles setup complete!"
    echo ""
    echo "Available commands:"
    ls -1 ~/.claude/commands/ | sed 's/\.md$//' | sed 's/^/  \//'
else
    echo "❌ Setup failed - please check the symlink manually"
    exit 1
fi

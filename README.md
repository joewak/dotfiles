# Dotfiles

Personal configuration files and global commands.

## Contents

- `.claude/commands/` - Global Claude Code custom commands

## Setup on a New Machine

1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the install script:
   ```bash
   ./install.sh
   ```

This will create a symlink from `~/.claude/commands` to `~/dotfiles/.claude/commands`, making all global commands available in Claude Code.

## Adding New Global Commands

1. Create a new `.md` file in `.claude/commands/`:
   ```bash
   cd ~/dotfiles
   touch .claude/commands/my-command.md
   ```

2. Edit the file with your command definition

3. Commit and push:
   ```bash
   git add .claude/commands/my-command.md
   git commit -m "Add my-command global command"
   git push
   ```

The command will be immediately available as `/my-command` in all projects.

## Available Commands

- `/ship-issue` - Complete workflow to close a GitHub issue (create branch, commit, push, PR, merge)

## Repository Structure

```
dotfiles/
├── .claude/
│   └── commands/         # Global Claude Code commands
│       └── ship-issue.md
├── install.sh           # Bootstrap script
└── README.md           # This file
```

## Notes

- Global commands are shared across all projects
- Project-specific commands should stay in each project's `.claude/commands/` directory
- This repo can be expanded to include other dotfiles (`.bashrc`, `.gitconfig`, etc.)

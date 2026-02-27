# Dotfiles Skills

Custom skills for managing this dotfiles repository with Claude Code.

## Available Skills

### `/setup` - Complete Development Setup

One-command setup for new machines. Handles everything from Homebrew packages to shell configuration.

See [setup/SKILL.md](setup/SKILL.md) for details.

### `/update` - Quick Dependency Update

Keep your system up-to-date with the latest packages from Homebrew and the Brewfile.

See [update/SKILL.md](update/SKILL.md) for details.

### `/push` - Smart Git Push

Intelligently analyze changes and push to GitHub with auto-generated commit messages.

See [push/SKILL.md](push/SKILL.md) for details.

## Skill Structure

Each skill is in its own directory with:
- `SKILL.md` - Skill metadata and documentation
- Shell script - The actual implementation

## Manual Operations

If you need more control, you can still use the Makefile directly:

```bash
# Dry run (check what will be linked)
make dryrun

# Link core dotfiles (git, tmux, zsh)
make

# Override existing files
make override

# Link specific terminal config
make kitty
make wezterm
make alacritty

# Install brew packages only
make brew
```

## Development

To create a new skill:

1. Create a new directory under `.claude/skills/`
2. Add a `SKILL.md` file with metadata and documentation
3. Add your implementation script
4. Update this README.md

Example SKILL.md structure:
```markdown
# Skill Name

Brief description

## Description
Detailed explanation

## What it does
- List of actions

## Usage
\```bash
/skill-name
\```

## Requirements
Dependencies and prerequisites
```

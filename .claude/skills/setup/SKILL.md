# Setup Skill

One-command local development setup - installs dependencies and configures dotfiles

## Description

Performs a full automated setup for the dotfiles repository on a new machine or fresh installation. This skill handles all the tedious setup steps in one go.

## What it does

- ✅ Checks for Homebrew installation
- ✅ Installs basic requirements (git, make, stow, zsh)
- ✅ Installs all packages from Brewfile
- ✅ Offers to set zsh as default shell
- ✅ Links all dotfiles using stow
- ✅ Optionally configures terminal emulator (kitty/wezterm/alacritty)
- ✅ Reminds you to update git email

## Usage

```bash
/setup
```

## When to use

- First time setting up dotfiles on a new machine
- After a fresh OS install
- When you want to ensure all dependencies are installed

## Requirements

- macOS with Homebrew installed
- Internet connection for package downloads

## Interactive prompts

The skill will ask you:
1. Whether to set zsh as your default shell
2. Which terminal emulator you use (if any)

## After running

Remember to:
1. Update your git email in `~/.gitconfig`
2. Restart your terminal or run `exec zsh`
3. Verify all packages installed correctly

## Troubleshooting

**Stow conflicts:**
- The script runs a dry-run first to check for conflicts
- If conflicts exist, you can run `make override` manually to adopt existing files

**Shell not changing:**
- You may need to fully restart your terminal application
- Or run: `exec zsh`

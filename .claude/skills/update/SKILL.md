# Update Skill

Quick dependency update - upgrades brew packages and syncs Brewfile

## Description

Quickly updates all Homebrew packages and ensures the Brewfile is in sync. Perfect for regular maintenance without reconfiguring everything.

## What it does

- ✅ Updates Homebrew itself
- ✅ Upgrades all installed packages
- ✅ Syncs packages from Brewfile
- ✅ Cleans up old versions
- ✅ Runs brew doctor to check for issues

## Usage

```bash
/update
```

## When to use

- Regular maintenance (weekly/monthly)
- After updating the Brewfile
- When you want to keep packages up-to-date
- Before starting work on a new project

## Requirements

- macOS with Homebrew installed
- Internet connection for package downloads

## What gets updated

- All brew formulae (CLI tools)
- All brew casks (GUI applications)
- Homebrew itself

## Time estimate

Usually takes 5-15 minutes depending on:
- Number of packages installed
- Number of packages that need updating
- Internet connection speed

## After running

The script will show a summary of:
- Total packages installed
- Any warnings from brew doctor (usually safe to ignore)

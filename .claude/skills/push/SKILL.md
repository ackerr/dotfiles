# Push Skill

Smart push to GitHub - automatically analyze changes and generate appropriate commit messages

## Description

Automatically analyzes git changes, generates semantic commit messages, and pushes to GitHub. No need to manually write commit messages - let AI understand your changes and generate standardized commit messages.

## What it does

- ✅ Check working directory status and changes
- ✅ Analyze git diff to understand specific modifications
- ✅ Intelligently generate standardized commit messages (follows Conventional Commits)
- ✅ Stage all changes
- ✅ Create commit
- ✅ Push to GitHub remote repository

## Usage

```bash
/push
```

Optional parameters:
```bash
/push "custom message"   # Use custom commit message
```

## Commit Message Format

Auto-generated commit messages follow this format:

```
<type>: <description>

[optional body]
```

Types include:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation updates
- `style`: Code formatting changes
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Test-related changes
- `chore`: Build process or auxiliary tool changes
- `update`: Configuration or dependency updates

## When to use

- Quick commit and push after completing feature development
- Daily configuration file updates
- Anytime you don't want to write commit messages manually
- When you need standardized commit history

## Requirements

- Git repository
- Configured GitHub remote repository
- Pending changes to commit
- gh CLI (optional, for better GitHub integration)

## What gets pushed

- All unstaged changes (modified files)
- All untracked files
- To the remote branch corresponding to the current branch

## Safety

- Shows content to be committed for confirmation before proceeding
- Automatically exits if there are no changes
- Prompts to pull first if remote has new commits

## Examples

Quick commit and push:
```bash
/push
```

Use custom message:
```bash
/push "feat: add new authentication flow"
```

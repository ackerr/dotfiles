#!/usr/bin/env bash
# Dotfiles Push Skill - Smart git push with AI-generated commit messages
# Analyzes changes and creates semantic commit messages

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

highlight() {
    echo -e "${CYAN}$1${NC}"
}

# Get the dotfiles directory (or current directory if run elsewhere)
if [ -d "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)" ]; then
    REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
else
    REPO_DIR="$(pwd)"
fi

info "Working in repository: $REPO_DIR"
cd "$REPO_DIR"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    error "Not a git repository!"
    exit 1
fi

# Check if there are any changes
if git diff --quiet && git diff --staged --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    info "No changes to commit. Working directory is clean."
    exit 0
fi

# Get custom message from argument
CUSTOM_MESSAGE="$1"

# Display current status
step "Checking git status..."
echo ""
git status --short
echo ""

# Function to generate commit message based on changes
generate_commit_message() {
    local status_output=$(git status --short)
    local diff_output=$(git diff --stat)
    local modified_files=$(echo "$status_output" | grep -E "^[ M]M" | wc -l | xargs)
    local new_files=$(echo "$status_output" | grep -E "^\?\?" | wc -l | xargs)
    local deleted_files=$(echo "$status_output" | grep -E "^[ M]D" | wc -l | xargs)

    # Analyze file types
    local has_config=$(echo "$status_output" | grep -E "\.(conf|config|yml|yaml|json|toml|ini|env)" | wc -l | xargs)
    local has_shell=$(echo "$status_output" | grep -E "\.(sh|bash|zsh)" | wc -l | xargs)
    local has_docs=$(echo "$status_output" | grep -E "\.(md|txt|rst)" | wc -l | xargs)
    local has_brew=$(echo "$status_output" | grep -E "Brewfile" | wc -l | xargs)
    local has_git=$(echo "$status_output" | grep -E "\.gitconfig|\.gitignore" | wc -l | xargs)

    # Determine commit type and message
    local commit_type="chore"
    local commit_desc="update dotfiles"

    if [ "$has_brew" -gt 0 ]; then
        commit_type="chore"
        commit_desc="update Brewfile dependencies"
    elif [ "$has_git" -gt 0 ]; then
        commit_type="chore"
        commit_desc="update git configuration"
    elif [ "$has_docs" -gt 0 ] && [ "$modified_files" -eq 1 ]; then
        commit_type="docs"
        commit_desc="update documentation"
    elif [ "$new_files" -gt 0 ] && [ "$modified_files" -eq 0 ]; then
        commit_type="feat"
        commit_desc="add new configuration files"
    elif [ "$has_config" -gt 0 ]; then
        commit_type="chore"
        commit_desc="update configuration"
    elif [ "$has_shell" -gt 0 ]; then
        commit_type="chore"
        commit_desc="update shell scripts"
    fi

    # Build commit message
    local message="${commit_type}: ${commit_desc}"

    # Add file details if needed
    if [ "$modified_files" -gt 0 ] || [ "$new_files" -gt 0 ] || [ "$deleted_files" -gt 0 ]; then
        message="${message}\n\n"
        [ "$modified_files" -gt 0 ] && message="${message}- Modified: ${modified_files} file(s)\n"
        [ "$new_files" -gt 0 ] && message="${message}- Added: ${new_files} file(s)\n"
        [ "$deleted_files" -gt 0 ] && message="${message}- Deleted: ${deleted_files} file(s)\n"
    fi

    echo -e "$message"
}

# Generate or use custom commit message
if [ -n "$CUSTOM_MESSAGE" ]; then
    COMMIT_MESSAGE="$CUSTOM_MESSAGE"
    info "Using custom commit message"
else
    step "Generating commit message..."
    COMMIT_MESSAGE=$(generate_commit_message)
    info "Generated commit message:"
fi

echo ""
highlight "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "$COMMIT_MESSAGE"
highlight "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Confirm before proceeding
read -p "Proceed with commit and push? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    warn "Push cancelled by user"
    exit 0
fi

# Stage all changes
step "Staging all changes..."
git add -A

# Create commit
step "Creating commit..."
git commit -m "$COMMIT_MESSAGE"
info "✓ Commit created successfully"

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
info "Current branch: $CURRENT_BRANCH"

# Check if remote branch exists
if git ls-remote --exit-code --heads origin "$CURRENT_BRANCH" >/dev/null 2>&1; then
    # Remote branch exists, check if we need to pull first
    step "Checking remote status..."
    git fetch origin "$CURRENT_BRANCH"

    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})
    BASE=$(git merge-base @ @{u})

    if [ "$LOCAL" = "$REMOTE" ]; then
        info "Local and remote are in sync"
    elif [ "$LOCAL" = "$BASE" ]; then
        warn "Remote has new commits. You should pull first!"
        read -p "Pull and rebase before pushing? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git pull --rebase origin "$CURRENT_BRANCH"
        else
            error "Push cancelled. Please pull first."
            exit 1
        fi
    elif [ "$REMOTE" = "$BASE" ]; then
        info "Local is ahead of remote, safe to push"
    else
        warn "Branches have diverged!"
        error "Please resolve manually (pull and merge/rebase)"
        exit 1
    fi
fi

# Push to remote
step "Pushing to GitHub..."
if git ls-remote --exit-code --heads origin "$CURRENT_BRANCH" >/dev/null 2>&1; then
    git push origin "$CURRENT_BRANCH"
else
    # First push, set upstream
    git push -u origin "$CURRENT_BRANCH"
    info "✓ Upstream branch created"
fi

info ""
info "════════════════════════════════════════════"
info "✓ Successfully pushed to GitHub!"
info "════════════════════════════════════════════"
info ""
info "Summary:"
info "  Branch: $CURRENT_BRANCH"
info "  Commit: $(git rev-parse --short HEAD)"
echo ""

# Show remote URL if available
REMOTE_URL=$(git config --get remote.origin.url)
if [ -n "$REMOTE_URL" ]; then
    info "Remote: $REMOTE_URL"
fi

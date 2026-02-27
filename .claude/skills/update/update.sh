#!/usr/bin/env bash
# Dotfiles Update Skill - Quick dependency updates
# This skill updates brew packages and ensures all dependencies are current

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Get the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

info "Updating dependencies from: $DOTFILES_DIR"
cd "$DOTFILES_DIR"

# Check Homebrew
if ! command -v brew &> /dev/null; then
    error "Homebrew is not installed!"
    exit 1
fi

# Step 1: Update Homebrew
step "Updating Homebrew..."
brew update

# Step 2: Upgrade installed packages
step "Upgrading installed packages..."
brew upgrade

# Step 3: Install/update packages from Brewfile
step "Syncing packages from Brewfile..."
if [ -f "brew/Brewfile" ]; then
    brew bundle --file=brew/Brewfile
    info "✓ Brewfile packages synced"
else
    warn "Brewfile not found at brew/Brewfile"
fi

# Step 4: Cleanup
step "Cleaning up old versions..."
brew cleanup

# Step 5: Check for issues
step "Running brew doctor..."
brew doctor || warn "brew doctor found some issues (this is usually fine)"

info ""
info "════════════════════════════════════════════"
info "✓ Dependencies updated successfully!"
info "════════════════════════════════════════════"
info ""
info "Summary:"
brew list --versions | wc -l | xargs echo "  Total packages installed:"

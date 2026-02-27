#!/usr/bin/env bash
# Dotfiles Setup Skill - One-command local development setup
# This skill automates the installation and configuration of dotfiles

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Get the dotfiles directory (assumes this script is in .claude/skills/setup/)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

info "Starting dotfiles setup from: $DOTFILES_DIR"
cd "$DOTFILES_DIR"

# Step 1: Check Homebrew
info "Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    error "Homebrew is not installed!"
    warn "Please install Homebrew first: https://brew.sh/"
    warn "Run: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi
info "✓ Homebrew found"

# Step 2: Install basic requirements
info "Installing basic requirements (git, make, stow, zsh)..."
brew install git make stow zsh

# Step 3: Install all brew packages from Brewfile
info "Installing packages from Brewfile..."
if [ -f "brew/Brewfile" ]; then
    brew bundle --file=brew/Brewfile
    info "✓ Brew packages installed"
else
    warn "Brewfile not found at brew/Brewfile"
fi

# Step 4: Set zsh as default shell (if not already)
info "Checking default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    warn "Current shell is not zsh"
    read -p "Would you like to set zsh as your default shell? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        chsh -s "$(which zsh)"
        info "✓ Default shell set to zsh (restart your terminal for changes to take effect)"
    else
        info "Skipping shell change"
    fi
else
    info "✓ zsh is already the default shell"
fi

# Step 5: Stow dotfiles
info "Linking dotfiles with stow..."
info "Running dry-run first to check for conflicts..."
if make dryrun; then
    info "No conflicts detected. Proceeding with linking..."
    make all
    info "✓ Dotfiles linked successfully"
else
    error "Conflicts detected during dry-run"
    warn "You can run 'make override' to adopt existing files"
    exit 1
fi

# Step 6: Check for terminal emulator preference
info "Checking terminal emulator configuration..."
read -p "Which terminal emulator do you use? (kitty/wezterm/alacritty/skip) " -r
case $REPLY in
    kitty)
        make kitty
        info "✓ Kitty config linked"
        ;;
    wezterm)
        make wezterm
        info "✓ WezTerm config linked"
        ;;
    alacritty)
        make alacritty
        info "✓ Alacritty config linked"
        ;;
    *)
        info "Skipping terminal emulator config"
        ;;
esac

# Step 7: Reminder about git config
warn "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
warn "IMPORTANT: Remember to update your git email!"
warn "Edit: ~/git/.gitconfig"
warn "Or run: git config --global user.email 'your@email.com'"
warn "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

info ""
info "════════════════════════════════════════════"
info "✓ Setup complete!"
info "════════════════════════════════════════════"
info ""
info "Next steps:"
info "  1. Update your git email in ~/.gitconfig"
info "  2. Restart your terminal or run: exec zsh"
info "  3. Enjoy your dotfiles! 🎉"

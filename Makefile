TARGET ?= ~

.PHONY: dryrun override kitty wezterm alacritty brew claude

all: dryrun
	stow git tmux zsh claude --target $(TARGET)

dryrun:
	stow git tmux zsh claude -n -v --target $(TARGET)

override:
	stow git tmux zsh claude --target $(TARGET) --adopt

claude:
	stow claude --target $(TARGET)

kitty:
	stow kitty --target $(TARGET)

wezterm:
	stow wezterm --target $(TARGET)

alacritty:
	stow alacritty --target $(TARGET)

brew:
	brew bundle --file=brew/Brewfile

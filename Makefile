TARGET ?= ~

.PHONY: dryrun override kitty wezterm alacritty brew claude lazygit

all: dryrun
	stow git tmux zsh claude lazygit --target $(TARGET)

dryrun:
	stow git tmux zsh claude lazygit -n -v --target $(TARGET)

override:
	stow git tmux zsh claude lazygit --target $(TARGET) --adopt

claude:
	stow claude --target $(TARGET)

lazygit:
	stow lazygit --target $(TARGET)

kitty:
	stow kitty --target $(TARGET)

wezterm:
	stow wezterm --target $(TARGET)

alacritty:
	stow alacritty --target $(TARGET)

brew:
	brew bundle --file=brew/Brewfile

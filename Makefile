TARGET ?= ~

.PHONY: stow dryrunn override kitty wezterm alacritty

stow:
	stow git tmux zsh --target $(TARGET)

dryrun:
	stow git tmux zsh -n -v --target $(TARGET)

override:
	stow git tmux zsh --target $(TARGET) --adopt

kitty:
	stow kitty --target $(TARGET)

wezterm:
	stow wezterm --target $(TARGET)

alacritty:
	stow alacritty --target $(TARGET)

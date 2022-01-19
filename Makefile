TARGET ?= ~

.PHONY: stow dryrunn override kitty

stow:
	stow git tmux zsh --target $(TARGET)

dryrun:
	stow git tmux zsh -n -v --target $(TARGET)

override:
	stow git tmux zsh --target $(TARGET) --adopt

kitty:
	stow kitty --target $(TARGET)

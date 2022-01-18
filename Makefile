TARGET ?= ~

.PHONY: stow dryrunn override kitty

stow:
	stow git nvim tmux zsh --target $(TARGET)

dryrun:
	stow git nvim tmux zsh -n -v --target $(TARGET)

override:
	stow git nvim tmux zsh --target $(TARGET) --adopt

kitty:
	stow kitty --target $(TARGET)

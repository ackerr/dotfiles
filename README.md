# Ackerr's dotfiles
![](https://github.com/Ackerr/dotfiles/workflows/CI/badge.svg)
![](https://github.com/Ackerr/dotfiles/workflows/Build/badge.svg)

## Requirements

- [homebrew](https://brew.sh/)

```bash
brew install git make stow zsh
```

## Installation 

### Clone repo 

```bash
git clone https://github.com/Ackerr/dotfiles.git && cd dotfiles
```

### Install brew packages

```bash
brew bundle --file=brew/Brewfile
```

### Set zsh as your default shell

```bash
chsh -s $(which zsh)
```

### Link all dotfiles

```bash
make stow
```

> Remember replace `.gitconfig` email

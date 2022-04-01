# auto load tmux
# https://github.com/romkatv/powerlevel10k/issues/1203
# if [ -z "$TMUX" ]; then
#   exec tmux new-session -A -s codespace
# fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

if [[ ! -d $HOME/.tmux/plugins/tpm/ ]]; then
    command mkdir -p "$HEOM/.tmux/plugins"
    command git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# zinit
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# plugins
autoload -Uz compinit
compinit

zinit ice lucid wait='1'
zinit light skywind3000/z.lua

zinit ice lucid wait'0b' from"gh-r" as"program"
zinit light junegunn/fzf

zinit ice lucid wait
zinit snippet OMZP::fzf
zinit snippet "https://github.com/junegunn/fzf/blob/master/shell/completion.zsh"
zinit snippet "https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh"

zinit ice lucid wait='1'
zinit light Aloxaf/fzf-tab

zinit ice lucid wait='1'
zinit light zdharma/fast-syntax-highlighting

zinit ice lucid wait='1' atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

zinit ice lucid wait='1'
zinit light zsh-users/zsh-completions
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh

zinit ice lucid wait='1'
zinit light paulirish/git-open

zinit ice lucid wait='1' as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

zinit ice lucid wait='1' from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
zinit light BurntSushi/ripgrep

zinit ice lucid wait='1' as"program" from"gh-r" mv"lazygit* -> lazygit"
zinit light 'jesseduffield/lazygit'

zinit ice lucid wait='1' as"program" from"gh-r" mv"lazydocker* -> lazydocker"
zinit light 'jesseduffield/lazydocker'

zinit ice lucid wait='1' as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd

# # vi-mode
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode


# p10k theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# zinit ice depth=1
# zinit light romkatv/powerlevel10k
#
# starship theme
zinit ice as"command" from"gh-r" \
    atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
    atpull"%atclone" src"init.zsh"
zinit light starship/starship

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
if [[ $TMUX != "" ]] then
    export TERM="tmux-256color"
# undercurl support
elif [[ -n $KITTY_WINDOW_ID ]] then
    export TERM="xterm-kitty"
elif [[ -n $WEZTERM_PANE ]] then
    export TERM="wezterm"
else
    export TERM="xterm-256color"
fi
export BAT_THEME='Dracula'
export EDITOR='nvim'

# python
export PATH="$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH"
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi

if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

# go
export GOPATH="$HOME/go-base"
export PATH="${GOPATH}:${GOPATH}/bin:${PATH}"
export GO111MODULE=on
export GOPROXY='https://goproxy.cn,direct'

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# fzf
bindkey '^T' fzf-file-widget
bindkey '^R' fzf-history-widget
export FZF_DEFAULT_COMMAND="fd --exclude={'env,.git,.vscode,.idea,node_moudles,__pycache__'} --hidden --follow"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --pointer='▶' --marker='✓' --preview-window=:70% --bind 'ctrl-f:page-down,ctrl-b:page-up,ctrl-a:toggle-all'"
export FZF_PREVIEW_OPTS="--preview 'bat --color=always --style=header,grid --line-range :300 {}'"
export FZF_CTRL_T_OPTS="$FZF_PREVIEW_OPTS"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type f"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

# alias
[ -f ~/.alias ] && source ~/.alias
[ -f ~/.profile ] && source ~/.profile
[ -f ~/.bash_profile ] && source ~/.bash_profile

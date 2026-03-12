if [[ ! -d $HOME/.tmux/plugins/tpm/ ]]; then
    command mkdir -p "$HOME/.tmux/plugins"
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

zinit ice lucid wait"1" as"command" from"gh-r" lucid \
  mv"zoxide*/zoxide -> zoxide" \
  atclone"./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit light ajeetdsouza/zoxide

zinit ice lucid wait'0b' from"gh-r" as"program"
zinit light junegunn/fzf

zinit ice lucid wait
zinit snippet "https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh"

# Load completions first (synchronous), then initialize compinit exactly once
zinit ice lucid
zinit light zsh-users/zsh-completions

autoload -Uz compinit
compinit

# fzf-tab MUST load after compinit but before autosuggestions
zinit ice lucid
zinit light Aloxaf/fzf-tab

zinit ice lucid wait='1'
zinit light zdharma/fast-syntax-highlighting

zinit ice lucid wait='1' atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

# Removed OMZ::lib/completion.zsh to avoid multiple compinit calls
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh

zinit ice lucid wait='1'
zinit light paulirish/git-open

zinit ice lucid wait='1' as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

zinit ice lucid wait='1' from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
zinit light BurntSushi/ripgrep

zinit ice lucid wait='1' as"program" from"gh-r" mv"lazygit* -> lazygit"
zinit light jesseduffield/lazygit

zinit ice lucid wait='1' as"program" from"gh-r" mv"lazydocker* -> lazydocker"
zinit light jesseduffield/lazydocker

zinit ice lucid wait='1' as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd

# vi-mode
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# https://github.com/jeffreytse/zsh-vi-mode/issues/15
function zvm_before_init() {
  zvm_bindkey viins '^[[A' history-beginning-search-backward
  zvm_bindkey viins '^[[B' history-beginning-search-forward
  zvm_bindkey vicmd '^[[A' history-beginning-search-backward
  zvm_bindkey vicmd '^[[B' history-beginning-search-forward
}

# starship theme
zinit ice as"command" from"gh-r" \
  atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
  atpull"%atclone" src"init.zsh" # pull behavior same as clone, source init.zsh
zinit light starship/starship

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
if [[ $TMUX != "" ]] then
    export TERM="tmux-256color"
# undercurl support
elif [[ -n $KITTY_WINDOW_ID ]] then
    export TERM="xterm-kitty"
# https://wezfurlong.org/wezterm/config/lua/config/term.html
# elif [[ -n $WEZTERM_PANE ]] then
#     export TERM="wezterm"
else
    export TERM="xterm-256color"
fi
export BAT_THEME='Dracula'
export EDITOR='nvim'

if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

# go
export GOPATH="$HOME/go-base"
export PATH="${GOPATH}/bin:${PATH}"
export GO111MODULE=on
export GOPROXY='https://goproxy.cn,direct'

# rust
export RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
export PATH="$HOME/.cargo/bin:$PATH"

# fzf
export FZF_DEFAULT_COMMAND="fd --exclude={'env,.git,.vscode,.idea,node_modules,__pycache__'} --hidden --follow"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --pointer='▶' --marker='✓' --preview-window=:70% --bind 'ctrl-f:page-down,ctrl-b:page-up,ctrl-a:toggle-all'"
export FZF_PREVIEW_OPTS="--preview 'bat --color=always --style=header,grid --line-range :300 {}'"
export FZF_CTRL_T_OPTS="$FZF_PREVIEW_OPTS"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type f"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

export FZF_CTRL_R_OPTS="
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export NVM_AUTO_USE=false  # Must be false when lazy loading is enabled

zinit light lukechilds/zsh-nvm

# Keep TAB completion deterministic even if later plugins alter keymaps/styles.
zstyle -d ':fzf-tab:*' accept-line
if (( ${+widgets[fzf-tab-complete]} )); then
  bindkey '^I' fzf-tab-complete
  bindkey -M emacs '^I' fzf-tab-complete
  bindkey -M viins '^I' fzf-tab-complete
else
  bindkey '^I' expand-or-complete
  bindkey -M emacs '^I' expand-or-complete
  bindkey -M viins '^I' expand-or-complete
fi
bindkey -M vicmd '^I' expand-or-complete

# alias
[ -f ~/.alias ] && source ~/.alias

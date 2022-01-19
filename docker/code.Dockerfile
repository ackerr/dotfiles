FROM ackerr/ackerr:base

ENV HOME /root
ENV GOPATH $HOME/go-base

WORKDIR $HOME

COPY . ./.dotfiles

# User Setting
RUN cd ./.dotfiles && make override && cd

# Init zsh
# https://github.com/zdharma/zinit/issues/484
# https://github.com/romkatv/powerlevel10k/issues/949
SHELL ["/bin/zsh", "-c"]

ENV TERM=${TERM:-xterm-256color} 
RUN zsh -isc "@zinit-scheduler burst"
RUN script -qec "zsh -is </dev/null" /dev/null 

# Init tmux plugin
RUN tmux start-server && \
    tmux new-session -d && \
    sleep 1 && \
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh && \
    tmux kill-server

# Init vim
RUN pip install pynvim && \
    npm install -g neovim && \
    nvim -E +PlugInstall +qall

ENTRYPOINT ["/bin/zsh"]

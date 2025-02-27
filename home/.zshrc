export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim
export BUN_INSTALL="$HOME/.bun"
export LANG=en_US.UTF-8
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.config/.foundry/bin:$PATH" # foundry
export PATH="$HOME/go/bin:$PATH" # go
export PATH="$BUN_INSTALL/bin:$PATH" # bun
export PATH="/Users/ale/.local/share/solana/install/active_release/bin:$PATH" # solana
export PATH="$HOME/Documents/zig-macos:$PATH" # zig
# XDG SPECS
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache
export NVM_HOMEBREW=$(brew --prefix nvm)
export NVM_DIR="$HOME/.nvm"

# load cargo to path
. "$HOME/.cargo/env"

# adds all the brew completions
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
ZSH_THEME="trapd00r" 

zstyle ':omz:plugins:nvm' lazy yes

plugins=(
        autojump
        nvm
        colored-man-pages 
        fzf
        git
        sudo
        zsh-autosuggestions
        zsh-syntax-highlighting
        )

source $ZSH/oh-my-zsh.sh

# git alias
alias gc="git checkout"
alias gs="git status"
alias gb="git branch"
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# gh alias
alias ghb="gh browse"

# cargo alias
alias ca="cargo add"
alias cc="cargo check"
alias cb="cargo build"
alias cr="cargo run"
alias clippy="cargo clippy"

# utils file system
alias c="code ." # open dir with vscode
alias ll="eza -a --icons --classify --sort=.name"
alias la="eza -l -a --classify --sort=.name"
alias ls="eza --icons --classify --sort=.name"
alias rmrf="rm -rf" # delete directory recursively

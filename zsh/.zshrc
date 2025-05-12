# Vim mode
bindkey -v

# Git abbreviations
alias gc="git checkout"
alias gs="git status"
alias gb="git branch"
alias glog="git log --color --graph --pretty --abbrev-commit"
alias gd="git diff | delta"
alias grh="git reset --hard"
alias gca="git commit --verbose --all --amend"
alias gpf="git push --force"
alias grv="git remote -v"
alias gfa="git fetch --all --prune"

alias gaa="git add ."
alias gcm="git commit -am" # stages all and commits
alias gp="git push"
alias gl="git pull --rebase"

# Neovim abbreviations
alias n="nvim ."
alias vi="nvim"
alias vim="nvim"

# Zoxide "ji"
alias jj="ji"

# GitHub CLI abbreviation
alias ghb="gh browse"

# Cargo abbreviations
alias ca="cargo add"
alias cc="cargo check"
alias cb="cargo build"
alias cbr="cargo build --release"
alias cbra="cargo build --release --target x86_64-apple-darwin --target aarch64-apple-darwin"
alias cr="cargo run"
alias ct="cargo test"
alias cf="cargo +nightly fmt"
alias clippy="cargo clippy"

# Bun abbreviations
alias brs="bun run start"
alias brb="bun run build"
alias br="bun run"
alias ba="bun add"
alias bt="bun test"

# Code
alias c="cursor ."
alias z="zed ."

# tmux
alias ta="tmux attach || tmux new -s alex"
alias tls="tmux ls"
alias tks="tmux kill-server"

# Eza
alias ls="eza --icons --classify --sort=modified --group-directories-last -I \"\$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')\""
# shows only `.` files
alias lx="eza -a -f --show-symlinks --icons --classify --sort=modified -I \"\$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')\""
# `.` and regular
alias ll="eza -a --icons --classify --sort=modified --group-directories-last -I \"\$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')\""
# long format
alias la="eza -l -a --no-user --icons --classify --sort=modified --group-directories-last -I \"\$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')\""
# tree list
alias tree="eza -T -a --level 2 --ignore-glob ''"

# Utility abbreviations
alias rmrf="rm -rf" # Delete directory recursively

# Better `cp`
alias cp="rsync -a"

eval "$(starship init zsh)"               # Starship prompt
eval "$(fnm env --use-on-cd --shell zsh)" # Not sure it this goes in .zshenv
eval "$(zoxide init --cmd j zsh)"         # Autojump

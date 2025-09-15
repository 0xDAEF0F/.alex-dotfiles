# only enable vi key bindings if connected to a keyboard
if status is-interactive
    set fish_greeting # no greeting

    fish_vi_key_bindings # vim mode

    starship init fish | source # starship prompt

    zoxide init fish | source # source zoxide

    # Override zoxide functions to add directory tracking
    function z
        __zoxide_z $argv
        track_current_dir
    end

    function zz
        __zoxide_zi $argv
        track_current_dir
    end

    # better history search
    atuin init fish --disable-up-arrow | source
end

fish_add_path $HOME/go/bin # go
fish_add_path $HOME/.bun/bin # bun
fish_add_path /opt/homebrew/bin # homebrew
fish_add_path $HOME/.config/.foundry/bin # foundry
fish_add_path $HOME/.zig/zig-macos # zig
fish_add_path $HOME/.local/bin # local scripts

# `set -U`: universal variable shared across fish sessions (not exported)
set -U fish_color_command blue

# `set -Ux`: universal exportable variable. and is available
# to child processes.
# set -Ux RUST_LOG info
set -Ux RUST_BACKTRACE 0

# this is not working
set -Ux MYVIMRC $HOME/.config/nvim/init.lua

# Bun
set -Ux BUN_INSTALL $HOME/.bun

# Eza
set -Ux EZA_CONFIG_DIR "$HOME/.config/eza"

# Editor
set -Ux EDITOR nvim

# XDG Specs
set -Ux XDG_CONFIG_HOME ~/.config
set -Ux XDG_DATA_HOME ~/.local/share
set -Ux XDG_STATE_HOME ~/.local/state
set -Ux XDG_CACHE_HOME ~/.cache

# Homebrew update time (never auto update)
set -Ux HOMEBREW_NO_ENV_HINTS true
set -Ux HOMEBREW_BAT true
set -Ux HOMEBREW_NO_AUTO_UPDATE true
set -Ux HOMEBREW_NO_ANALYTICS true

# Claude
abbr -a cl claude
abbr -a clc "claude --continue"
abbr -a clr "claude --resume"
abbr -a yolo "claude --dangerously-skip-permissions"

abbr -a ze "zed . && exit"

abbr -a pp pbpaste

# Binds history pager to `C-r` just like the old times
bind -M insert \cr _atuin_search
bind -M default \cr _atuin_search

# Git abbreviations
abbr -a gs "git status"
abbr -a gd "git diff"
abbr -a gds "git diff --staged"
abbr -a gdc "git diff --cached"
abbr -a glog "git log --color --graph --pretty --abbrev-commit"
abbr -a grv "git remote -v"
abbr -a gcl "git clean -fd"

abbr -a grh "git reset --hard"
abbr -a grs "git reset --soft"

abbr -a gaa "git add ."
abbr -a gcm "git commit -m"
abbr -a gca! "git commit --verbose --all --amend"
abbr -a gpf "git push --force-with-lease"
abbr -a gp "git push"
abbr -a gsc "git stash clear"

abbr -a gb "git branch"
abbr -a gbd "git branch -D"
abbr -a gc "git checkout"
abbr -a gcb "git checkout -b"
abbr -a gcmm "git checkout master || git checkout main"

abbr -a gfa "git fetch --all --prune && git status"
abbr -a gl "git pull --ff-only"

# Neovim abbreviations
abbr -a n nvim

# utils
abbr -a o "open ." # open file explorer
abbr -a chx "chmod +x" # change file to executable
abbr -a src "source ~/.config/fish/config.fish" # source config

# GitHub CLI abbreviation
abbr -a ghb "gh browse"
abbr -a ghbb "gh browse -b (git branch --show-current)" # open current git branch in github

# Cargo abbreviations
abbr -a ca "cargo add"
abbr -a cc "cargo check"
abbr -a cb "cargo build"
abbr -a cbr "cargo build --release"
abbr -a cbra "cargo build --release --target x86_64-apple-darwin --target aarch64-apple-darwin"
abbr -a cr "cargo run"
abbr -a ct "cargo test"
abbr -a cf "cargo +nightly fmt"
abbr -a clippy "cargo clippy"
abbr -a cfa "cargo fix --allow-dirty && cargo clippy --fix --allow-dirty && cargo +nightly fmt"
abbr -a crw "cargo watch -x run"
abbr -a rebuild "cargo clean && cargo build"

abbr -a grbm "git fetch --all && git rebase origin/master"
abbr -a grbi "git rebase --interactive"
abbr -a grba "git rebase --abort"

abbr -a testy "cargo nextest run --success-output immediate --no-capture"

# Homebrew abbreviations
abbr -a bi "brew install"
abbr -a bu "brew uninstall"
abbr -a bic "brew install --cask"
abbr -a buc "brew uninstall --cask --zap"

# Tauri
abbr -a td "bunx tauri dev --no-watch"

# Bun abbreviations
abbr -a brs "bun run start"
abbr -a brb "bun run build"
abbr -a br "bun run"
abbr -a ba "bun add"
abbr -a bt "bun test"

# npm abbr with bun xd
abbr -a blsg "bun pm ls -g"
abbr -a big "bun install -g"
abbr -a bx bunx

# tmux
abbr -a ta "tmux attach || tmux new -s alex"
abbr -a tls "tmux ls"
abbr -a tks "tmux kill-server"

# opt+l
bind -M insert \el 'commandline -r "ls"; commandline -f execute'

abbr -a ls eza # list dirs and files
abbr -a ll "eza -a" # list dirs and files (hidden included)
abbr -a la "eza -la --no-user" # list dirs and files (hidden included) in long format

# Better `cp`
abbr -a cp "rsync -a"

# Previous directory
abbr -a \- prevd

# make `y` work like in vim
bind -M visual y fish_clipboard_copy
bind -M normal yy fish_clipboard_copy
bind p fish_clipboard_paste

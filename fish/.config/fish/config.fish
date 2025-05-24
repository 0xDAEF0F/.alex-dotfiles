# `set -U`: universal variable shared across fish sessions.
# they are not exported to the environment.

# `set -Ux`: universal exportable variable. and is available
# to child processes.

fish_add_path $HOME/go/bin               # go
fish_add_path $HOME/.bun/bin             # bun
fish_add_path /opt/homebrew/bin          # homebrew
fish_add_path $HOME/.config/.foundry/bin # foundry
fish_add_path $HOME/.zig/zig-macos       # zig
fish_add_path $HOME/.local/bin           # local scripts

# this should work without doing this but it does not
source ~/.config/fish/completions/tauri.fish

starship init fish | source       # source starship
zoxide init --cmd j fish | source # source zoxide

fish_vi_key_bindings

set -U fish_greeting ""
set -U fish_color_command blue

set -Ux RUST_LOG "fnm=warn,cursor_quota=debug"

# Bun
set -Ux BUN_INSTALL $HOME/.bun

# Editor
set -Ux EDITOR "nvim"

# XDG Specs
set -Ux XDG_CONFIG_HOME ~/.config
set -Ux XDG_DATA_HOME ~/.local/share
set -Ux XDG_STATE_HOME ~/.local/state
set -Ux XDG_CACHE_HOME ~/.cache

# Homebrew update time (never auto update)
set -Ux HOMEBREW_AUTO_UPDATE_SECS 9999999999

# Binds history pager to `C-r` just like the old times
bind -M insert \cr 'commandline -f history-pager'
bind -M default \cr 'commandline -f history-pager'

# Git abbreviations
abbr -a gc "git checkout"
abbr -a gs "git status"
abbr -a gb "git branch"
abbr -a glog "git log --color --graph --pretty --abbrev-commit"
abbr -a gd "git diff | delta"
abbr -a grh "git reset --hard"
abbr -a gca! "git commit --verbose --all --amend"
abbr -a gpf "git push --force"
abbr -a grv "git remote -v"
abbr -a gfa "git fetch --all --prune"

abbr -a gaa "git add ."
abbr -a gcm "git commit -am" # stages all and commits
abbr -a gp "git push"
abbr -a gl "git pull --rebase"

# Neovim abbreviations
abbr -a n "nvim ."
abbr -a vi "nvim"

# Zoxide "ji"
abbr -a jj "ji"

# GitHub CLI abbreviation
abbr -a ghb "gh browse"

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

# Bun abbreviations
abbr -a brs "bun run start"
abbr -a brb "bun run build"
abbr -a br "bun run"
abbr -a ba "bun add"
abbr -a bt "bun test"

# Npm
abbr -a nls "npm ls -g"

# Code
abbr -a c "cursor ."
abbr -a z "zed ."

# tmux
abbr -a ta "tmux attach || tmux new -s alex"
abbr -a tls "tmux ls"
abbr -a tks "tmux kill-server"

# Eza
abbr -a ls "eza --icons --classify --sort=modified --group-directories-last\
  -I "\"$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')"\""
# shows only `.` files
abbr -a lx "eza -a -f --show-symlinks --icons --classify --sort=modified\
  -I "\"$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')"\""
# `.` and regular
abbr -a ll "eza -a --icons --classify --sort=modified --group-directories-last\
  -I "\"$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')"\""
# long format
abbr -a la "eza -l -a --no-user --icons --classify --sort=modified --group-directories-last\
  -I "\"$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')"\""
# tree list
abbr -a tree "eza -T -a --level 2 --ignore-glob ''"

# Utility abbreviations
abbr -a rmrf "rm -rf" # Delete directory recursively

# Better `cp`
abbr -a cp "rsync -a"

# Previous directory
abbr -a \- prevd

# make `y` work like in vim
bind -M visual y fish_clipboard_copy
bind -M normal yy fish_clipboard_copy
bind p fish_clipboard_paste

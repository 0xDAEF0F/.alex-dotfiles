# `set -U`: universal variable shared across fish sessions.
# they are not exported to the environment.

# `set -Ux`: universal exportable variable. and is available
# to child processes.

fish_add_path $HOME/go/bin # go
fish_add_path $HOME/.bun/bin # bun
fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.config/.foundry/bin # foundry
fish_add_path $HOME/.zig/zig-macos # zig

fnm env | source # source fnm
starship init fish | source # source starship

# enable vi cursor in Ghostty
if status is-interactive
    if string match -q -- '*ghostty*' $TERM
        set -g fish_vi_force_cursor 1
    end
end

# source autojump
begin
    set --local AUTOJUMP_PATH /opt/homebrew/share/autojump/autojump.fish
    if test -e $AUTOJUMP_PATH
        source $AUTOJUMP_PATH
    end
end

# Cursor styles
set -U fish_cursor_default "block"
set -U fish_cursor_insert "line" "blink"
set -U fish_cursor_replace_one "underscore"
set -U fish_cursor_visual "block"

# Bun
set -Ux BUN_INSTALL $HOME/.bun

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
abbr -a glog "git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
abbr -a gd "git diff"
abbr -a grh "git reset --hard"
abbr -a gaa "git add ."
abbr -a gca! "git commit --verbose --all --amend"
abbr -a gcm "git commit -m"
abbr -a gp "git push"
abbr -a grv "git remote -v"

# GitHub CLI abbreviation
abbr -a ghb "gh browse"

# Cargo abbreviations
abbr -a ca "cargo add"
abbr -a cc "cargo check"
abbr -a cb "cargo build"
abbr -a cr "cargo run"
abbr -a cf "cargo +nightly fmt"
abbr -a clippy "cargo clippy"

# Code
abbr -a c "cursor ." 

# tmux
abbr -a ta "tmux attach" 
abbr -a tn "tmux new -s alex"
abbr -a tks "tmux kill-server"

# Eza
abbr -a ls "eza -w 90 --icons --classify --sort=modified --group-directories-last\
  -I "\"$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')"\""
# shows only `.` files
abbr -a lx "eza -a -f -w 90 --show-symlinks --icons --classify --sort=modified\
  -I "\"$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')"\""
# `.` and regular
abbr -a ll "eza -a --width 90 --icons --classify --sort=modified --group-directories-last\
  -I "\"$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')"\""
# long format
abbr -a la "eza -l -a --no-user --icons --classify --sort=modified --group-directories-last\
  -I "\"$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')"\""
# tree list
abbr -a tree "eza -T -a --level 2 --ignore-glob ''"

# Utility abbreviations
abbr -a rmrf "rm -rf" # Delete directory recursively

# Better `cp` and `mv`
abbr -a cp "rsync -a --progress --human-readable"
abbr -a mv "rsync -a --progress --human-readable --remove-source-files"

# make `y` work like in vim
bind -M visual y fish_clipboard_copy
bind -M normal yy fish_clipboard_copy
bind p fish_clipboard_paste

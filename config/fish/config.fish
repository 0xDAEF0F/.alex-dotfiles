/opt/homebrew/bin/brew shellenv | source # dont know if this is needed at all

set -Ux XDG_CONFIG_HOME ~/.config
set -Ux HOMEBREW_AUTO_UPDATE_SECS 86400

# Git abbreviations
abbr -a gc "git checkout"
abbr -a gs "git status"
abbr -a gb "git branch"
abbr -a glog "git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
abbr -a gd "git diff"
abbr -a grh "git reset --hard"
abbr -a gaa "git add ."
abbr -a gca! "git commit --verbose --all --amend"
abbr -a gp "git push"

abbr -a lc "history | head -n 1 | pbcopy"

# GitHub CLI abbreviation
abbr -a ghb "gh browse"

# Cargo abbreviations
abbr -a ca "cargo add"
abbr -a cc "cargo check"
abbr -a cb "cargo build"
abbr -a cr "cargo run"
abbr -a clippy "cargo clippy"

# Code
abbr -a c "cursor ." 

# tmux
abbr -a ta "tmux attach" 
abbr -a tn "tmux new -s alex"
abbr -a tks "tmux kill-server"

# Eza
abbr -a ls "eza -w 90 --icons --classify --sort=modified --group-directories-last -I "\"$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')"\""
abbr -a lx "eza -a -f -w 90 --show-symlinks --icons --classify --sort=modified -I "\"$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')"\""
abbr -a ll "eza -a --width 90 --icons --classify --sort=modified --group-directories-last -I "\"$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')"\""
abbr -a la "eza -l -a --no-user --icons --classify --sort=modified --group-directories-last -I "\"$(grep -v '^#\|^$' ~/.gitignore_global | tr '\n' '|' | sed 's/|$//')"\""
abbr -a tree "eza -T -a --level 3 --ignore-glob ''"

# Utility abbreviations
abbr -a rmrf "rm -rf" # Delete directory recursively

# source autojump
begin
    set --local AUTOJUMP_PATH /opt/homebrew/share/autojump/autojump.fish
    if test -e $AUTOJUMP_PATH
        source $AUTOJUMP_PATH
    end
end

function jj
    set -l output (cat ~/Library/autojump/autojump.txt | sort -nr | awk '{print $2}' | fzf --height 40%)
    if test -n "$output"
        cd "$output"
    end
end

bind -M visual y fish_clipboard_copy
bind -M normal yy fish_clipboard_copy
bind p fish_clipboard_paste

starship init fish | source

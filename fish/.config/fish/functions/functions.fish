# yazi shortcut
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# call llm-term with cursor output
function ai
    set --local cursor_output (llm-term --disable-cache $argv)
    commandline -i $cursor_output
end

function take
    set --local file_name $argv
    mkdir -p $file_name
    cd $file_name
end

# use terminal-notifier to notify when a command finishes
function notify
    $argv
    echo Finish | terminal-notifier -sound default
end

# open cursor in current directory
function c
    genv --ignore-environment \
        /usr/local/bin/cursor .
end

# modified "ls" with better defaults
function eza
    command eza --width 95 --icons --classify --sort modified --reverse $argv
end

# if the arguments is a directory, remove it recursively, otherwise remove the file
function rm
    if test -d "$argv[1]"
        command rm -rf $argv
    else
        command rm $argv
    end
end

function set_abbr
    if test (count $argv) -eq 2
        echo "abbr -a $argv[1] $argv[2]" >>~/.config/fish/config.fish
        echo "Added abbr $argv[1] -> $argv[2]"
    else
        echo "Usage: add_abbr <abbr> <command>"
    end
end

function llr
    commandline "ll | rg \"\""
    commandline --cursor (math (commandline --cursor) - 1)
end

# clears a file of duplicate entries (rows)
function _dedup_file
    if not set -q argv[1]
        echo "Usage: dedup_file <file>"
        return 1
    end

    set file $argv[1]

    if not test -f $file
        echo "File not found: $file"
        return 1
    end

    awk '!seen[$0]++' $file > $file.tmp && mv $file.tmp $file
end

# track recent directories
function _track_recent_dir --on-variable PWD --description 'Tracks the current directory'
    set --local recent_dirs_file ~/.local/share/fish/recent_dirs
    set --local current_dir (pwd)
    
    # echo "Debug: $current_dir"
    
    # create directory if it doesn't exist
    mkdir -p (dirname $recent_dirs_file)
    
    # don't track some directories
    if test "$current_dir" = "$HOME" || test "$current_dir" = "/" || test "$current_dir" = "$HOME/google-cloud-sdk"
        return
    end
    
    # just append current directory
    echo $current_dir >> $recent_dirs_file
    _dedup_file $recent_dirs_file
end

# fzf picker for recent directories
function rr
    set --local recent_dirs_file ~/.local/share/fish/recent_dirs
    
    if not test -f $recent_dirs_file
        echo "No recent directories found"
        return 1
    end
    
    # get last 10 unique directories that exist
    set --local selected_dir (tail -r -n 10 $recent_dirs_file | while read -l dir
        if test -d "$dir"
            echo $dir
        end
    end | fzf --height=40% --reverse --prompt="Recent dirs: " --preview 'fd . --base-directory {} --max-depth 1 --color always --strip-cwd-prefix' --preview-window 'right:50%')
    
    if test -n "$selected_dir"
        cd "$selected_dir"
    end
end

# git clone and cd into it
function clone
    if test (count $argv) -eq 2
        git clone $argv[1] $argv[2] && cd $argv[2]
    else
        set repo_name (basename $argv[1] .git)
        git clone $argv[1] && cd $repo_name
    end
end

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

function add_abbr
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

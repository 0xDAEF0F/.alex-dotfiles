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
    echo 'Finish' | terminal-notifier -sound default
end

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

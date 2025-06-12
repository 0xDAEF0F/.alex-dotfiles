function track_current_dir
    set --local recent_dirs_file ~/.local/share/fish/recent_dirs
    set --local current_dir (pwd)
    
    # create directory if it doesn't exist
    mkdir -p (dirname $recent_dirs_file)
    
    # don't track some directories
    if test "$current_dir" = "$HOME" || test "$current_dir" = "/" || test "$current_dir" = "$HOME/google-cloud-sdk"
        return
    end
    
    # remove the directory if it already exists in the file, then append it
    # this ensures most recently visited dirs are at the end
    if test -f $recent_dirs_file
        grep -v "^$current_dir\$" $recent_dirs_file > $recent_dirs_file.tmp 2>/dev/null || true
        mv $recent_dirs_file.tmp $recent_dirs_file
    end
    
    # append current directory
    echo $current_dir >> $recent_dirs_file
end
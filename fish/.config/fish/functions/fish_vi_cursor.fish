function fish_vi_cursor --on-variable fish_bind_mode
    switch $fish_bind_mode
        case insert
            # Blinking bar in insert mode
            printf '\e[5 q'
        case default
            # Blinking block in normal mode
            printf '\e[1 q'
        case visual
            # Blinking block in visual mode
            printf '\e[1 q'
        case replace replace_one
            # Blinking underline in replace mode
            printf '\e[3 q'
    end
end

# Set initial cursor
fish_vi_cursor
# My Dotfiles 🥹

## Instructions

1. make sure `brew` is installed on the system.

### Note

    - to stow "config" `stow --target=$XDG_CONFIG_HOME config`
    - to stow "home" `stow --target=$HOME home`
    - to stow "cursor" `stow --target=$HOME/Library/Application\ Support/Cursor/User cursor`

- navigate into the directory.
- to stow/unstow:
  - to stow: `stow --target=$HOME {stow_package}`.
  - to unstow: `stow --target=$HOME --delete {stow_package}`.

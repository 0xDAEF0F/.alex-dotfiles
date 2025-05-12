export PATH=$PATH:/opt/homebrew/bin          # Homebrew
export PATH=$PATH:$HOME/go/bin               # go
export PATH=$PATH:$HOME/.bun/bin             # bun
export PATH=$PATH:$HOME/.config/.foundry/bin # foundry
export PATH=$PATH:$HOME/.zig/zig-macos       # zig

# Homebrew update time (never auto update)
export HOMEBREW_AUTO_UPDATE_SECS=9999999999

# Bun
export BUN_INSTALL=$HOME/.bun

# Editor
export EDITOR="nvim"

# XDG Specs
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

. "$HOME/.cargo/env" # Source Rust

# Set XDG Base Directory Specification early
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Set ZDOTDIR to use XDG-compliant config directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

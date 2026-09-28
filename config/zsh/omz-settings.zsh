# Oh My Zsh Configuration Settings
# Sourced by .zshrc before loading oh-my-zsh framework
# See: https://github.com/ohmyzsh/ohmyzsh/wiki

export ZSH="$XDG_CONFIG_HOME/oh-my-zsh"

# Theme Configuration
# Set to "random" to load a random theme each time
# See: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment to pick from specific random themes:
# ZSH_THEME="random"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Auto-update Behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# zstyle ':omz:update' frequency 13   # update frequency in days

# Completion Options
# CASE_SENSITIVE="true"               # use case-sensitive completion
# HYPHEN_INSENSITIVE="true"           # _ and - will be interchangeable
ENABLE_CORRECTION="true"       # enable command auto-correction
COMPLETION_WAITING_DOTS="true" # display dots while waiting for completion

# Performance Options
# DISABLE_UNTRACKED_FILES_DIRTY="true"  # faster git status in large repos

# Display Options
# DISABLE_MAGIC_FUNCTIONS="true"      # fix issues with pasting URLs
# DISABLE_LS_COLORS="true"            # disable colors in ls
DISABLE_AUTO_TITLE="true"
# HIST_STAMPS="mm/dd/yyyy"            # history command timestamp format

# Custom Folder (if you want to use a different location than $ZSH/custom)
# ZSH_CUSTOM=/path/to/new-custom-folder

# Plugins
# Standard plugins: $ZSH/plugins/
# Custom plugins: $ZSH_CUSTOM/plugins/
# Add wisely - too many plugins slow down shell startup
#
# ┌─────────────────────────┬──────────────────────────────────────────────────┐
# │ Plugin                  │ Summary                                          │
# ├─────────────────────────┼──────────────────────────────────────────────────┤
# │ git                     │ Git aliases and functions                        │
# │ gitfast                 │ Faster git tab completion                        │
# │ colored-man-pages       │ Colorize man pages for readability               │
# │ extract                 │ Universal archive extractor (x command)          │
# │ macos                   │ macOS utilities (ofd, pfd, etc.)                 │
# │ brew                    │ Homebrew aliases and completion                  │
# │ rails                   │ Rails aliases and tab completion                 │
# │ bundler                 │ Bundler aliases (be, bi, etc.)                   │
# │ rbenv                   │ Ruby version manager integration                 │
# │ docker                  │ Docker aliases and completion                    │
# │ docker-compose          │ Docker Compose tab completion                    │
# │ fzf                     │ Fuzzy finder integration (Ctrl-R, Ctrl-T)        │
# │ sudo                    │ Press ESC twice to prefix last cmd with sudo     │
# │ z                       │ Jump to frequent directories (z keyword)         │
# │ command-not-found       │ Suggests packages for missing commands           │
# │ copypath                │ Copy current directory path to clipboard         │
# │ copyfile                │ Copy file contents to clipboard                  │
# │ history-substring-search│ Fish-like history search (up/down arrows)        │
# │ postgres                │ PostgreSQL service aliases                       │
# │ nvm                     │ Node Version Manager integration                 │
# │ jsontools               │ JSON formatting (pp_json, is_json, etc.)         │
# │ web-search              │ Search engines from CLI (google, ddg, etc.)      │
# │ tips                    │ [Custom] Random shell tips on startup            │
# │ (removed: api-service-dev - replaced by Docker Compose)                    │
# │ zsh-autosuggestions     │ Fish-like command autosuggestions (gray text)    │
# │ zsh-syntax-highlighting │ Syntax highlighting for commands as you type     │
# └─────────────────────────┴──────────────────────────────────────────────────┘
plugins=(
  git gitfast colored-man-pages extract macos brew
  rbenv docker docker-compose fzf
  sudo z command-not-found copypath copyfile history-substring-search
  postgres nvm jsontools web-search
  tips
  zsh-autosuggestions zsh-syntax-highlighting
)

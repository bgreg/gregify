#!/usr/bin/env bash

VERSION="2.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUBY_VERSION="3.3.6"
NODE_VERSION="22.18.0"
BREW_PREFIX="${BREW_PREFIX:-/opt/homebrew}"
BACKUP_SUFFIX="backup.$(date +%Y%m%d_%H%M%S)"

LINKS=(
    "home/.zshenv:.zshenv"
    "config/zsh/.zshrc:.config/zsh/.zshrc"
    "config/zsh/.zprofile:.config/zsh/.zprofile"
    "config/zsh/omz-settings.zsh:.config/zsh/omz-settings.zsh"
    "config/zsh/QUICK_REFERENCE.md:.config/zsh/QUICK_REFERENCE.md"
    "config/zsh/scripts/backup_dev_env.sh:.config/zsh/scripts/backup_dev_env.sh"
    "config/zsh/scripts/cal-count.sh:.config/zsh/scripts/cal-count.sh"
    "config/zsh/scripts/cal-create-recurring.sh:.config/zsh/scripts/cal-create-recurring.sh"
    "config/zsh/scripts/cal-delete-pattern.sh:.config/zsh/scripts/cal-delete-pattern.sh"
    "config/zsh/scripts/cal-delete.sh:.config/zsh/scripts/cal-delete.sh"
    "config/zsh/scripts/cal-on.sh:.config/zsh/scripts/cal-on.sh"
    "config/zsh/scripts/cal-today.sh:.config/zsh/scripts/cal-today.sh"
    "config/zsh/scripts/cal-upcoming.sh:.config/zsh/scripts/cal-upcoming.sh"
    "config/zsh/scripts/chrome-session.sh:.config/zsh/scripts/chrome-session.sh"
    "config/zsh/scripts/clear-desktop.sh:.config/zsh/scripts/clear-desktop.sh"
    "config/zsh/scripts/github-overview.sh:.config/zsh/scripts/github-overview.sh"
    "config/zsh/scripts/rem-add.sh:.config/zsh/scripts/rem-add.sh"
    "config/zsh/scripts/rem-delete.sh:.config/zsh/scripts/rem-delete.sh"
    "config/zsh/scripts/rem-done.sh:.config/zsh/scripts/rem-done.sh"
    "config/oh-my-zsh/custom/aliases.zsh:.config/oh-my-zsh/custom/aliases.zsh"
    "config/oh-my-zsh/custom/functions.zsh:.config/oh-my-zsh/custom/functions.zsh"
    "config/oh-my-zsh/custom/plugins/tips:.config/oh-my-zsh/custom/plugins/tips"
    "config/nvim:.config/nvim"
    "config/git/config:.config/git/config"
    "config/git/ignore:.config/git/ignore"
    "config/git/hooks:.config/git/hooks"
    "config/fzf/fzf.zsh:.config/fzf/fzf.zsh"
    "config/iterm-profile-wrappers:.config/iterm-profile-wrappers"
    "config/iterm-profile-wrappers/claude-profile:bin/claude-profile"
    "config/iterm-profile-wrappers/nvim-profile:bin/nvim-profile"
    "config/iterm-profile-wrappers/vim-profile:bin/vim-profile"
)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║          Greg's Development Environment Setup v${VERSION}         ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
}

link_path() {
    local src="$1"
    local dst="$2"
    if [[ ! -e "$src" ]]; then
        log_error "Missing link source: $src"
        return 1
    fi
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        log_success "Already linked: $dst"
        return 0
    fi
    if [[ -e "$dst" || -L "$dst" ]]; then
        mv "$dst" "$dst.$BACKUP_SUFFIX"
        log_warning "Backed up $dst to $dst.$BACKUP_SUFFIX"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    log_success "Linked $dst -> $src"
}

link_files() {
    log_info "Linking configuration files..."
    local entry
    for entry in "${LINKS[@]}"; do
        link_path "$SCRIPT_DIR/${entry%%:*}" "$HOME/${entry#*:}"
    done
}

print_links() {
    local entry
    for entry in "${LINKS[@]}"; do
        printf '%s\t%s\n' "${entry%%:*}" "${entry#*:}"
    done
}

check_prerequisites() {
    log_info "Checking prerequisites..."
    if [[ "$OSTYPE" != darwin* ]]; then
        log_error "This script supports macOS only (OSTYPE=$OSTYPE)"
        exit 1
    fi
    log_success "Running on macOS"
}

capture_git_identity() {
    GIT_IDENTITY_NAME="$(git config --global user.name 2>/dev/null || true)"
    GIT_IDENTITY_EMAIL="$(git config --global user.email 2>/dev/null || true)"
    GIT_IDENTITY_NAME="${GIT_IDENTITY_NAME:-${GIT_AUTHOR_NAME:-}}"
    GIT_IDENTITY_EMAIL="${GIT_IDENTITY_EMAIL:-${GIT_AUTHOR_EMAIL:-}}"
}

write_git_identity() {
    local file="$HOME/.config/git/config.local"
    if [[ -f "$file" ]]; then
        log_success "Git identity already present at $file"
        return 0
    fi
    if [[ -t 0 ]]; then
        if [[ -z "${GIT_IDENTITY_NAME:-}" ]]; then
            read -r -p "Git user.name: " GIT_IDENTITY_NAME
        fi
        if [[ -z "${GIT_IDENTITY_EMAIL:-}" ]]; then
            read -r -p "Git user.email: " GIT_IDENTITY_EMAIL
        fi
    fi
    if [[ -z "${GIT_IDENTITY_NAME:-}" || -z "${GIT_IDENTITY_EMAIL:-}" ]]; then
        log_warning "Git identity is incomplete; edit $file before committing"
    fi
    mkdir -p "$(dirname "$file")"
    printf '[user]\n\tname = %s\n\temail = %s\n' "${GIT_IDENTITY_NAME:-}" "${GIT_IDENTITY_EMAIL:-}" > "$file"
    log_success "Wrote git identity to $file"
}

warn_legacy_files() {
    log_info "Checking for legacy shell files zsh no longer reads..."
    local file
    for file in "$HOME/.zshrc" "$HOME/.zprofile" "$HOME/.bash_profile" "$HOME/.bashrc"; do
        if [[ -f "$file" && ! -L "$file" ]]; then
            log_warning "$file exists but is not read because ZDOTDIR points at ~/.config/zsh"
        fi
    done
}

omz_dir() {
    echo "$HOME/.config/oh-my-zsh"
}

install_homebrew() {
    if [[ -x "$BREW_PREFIX/bin/brew" ]]; then
        log_success "Homebrew already installed at $BREW_PREFIX"
    else
        log_info "Installing Homebrew..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ ! -x "$BREW_PREFIX/bin/brew" ]]; then
            log_error "Homebrew did not install to $BREW_PREFIX; only Apple Silicon Macs are supported"
            exit 1
        fi
        log_success "Homebrew installed"
    fi
    eval "$("$BREW_PREFIX/bin/brew" shellenv)"
}

create_directories() {
    log_info "Creating XDG directory structure..."
    local dir
    for dir in .config .local/share .cache .config/zsh/scripts .config/nvm .config/rbenv .config/git .config/fzf bin; do
        mkdir -p "$HOME/$dir"
    done
    log_success "Directories ready"
}

install_brew_packages() {
    log_info "Installing Homebrew packages from Brewfile..."
    if brew bundle install --no-upgrade --file="$SCRIPT_DIR/Brewfile"; then
        log_success "Brewfile satisfied"
    else
        log_warning "brew bundle reported failures; run: brew bundle check --no-upgrade --verbose --file=$SCRIPT_DIR/Brewfile"
    fi
}

install_oh_my_zsh() {
    local dir
    dir="$(omz_dir)"
    if [[ -f "$dir/oh-my-zsh.sh" ]]; then
        log_success "Oh My Zsh already installed at $dir"
        return 0
    fi
    log_info "Installing Oh My Zsh..."
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$dir"
    log_success "Oh My Zsh installed"
}

install_zsh_plugins() {
    local name dir
    for name in zsh-autosuggestions zsh-syntax-highlighting; do
        dir="$(omz_dir)/custom/plugins/$name"
        if [[ -d "$dir" ]]; then
            log_success "$name already installed"
        else
            log_info "Installing $name..."
            git clone --depth=1 "https://github.com/zsh-users/$name.git" "$dir"
        fi
    done
}

install_ruby() {
    log_info "Installing Ruby $RUBY_VERSION via rbenv..."
    export RBENV_ROOT="$HOME/.config/rbenv"
    rbenv install --skip-existing "$RUBY_VERSION"
    rbenv global "$RUBY_VERSION"
    log_success "Ruby $RUBY_VERSION is the rbenv global version"
}

install_node() {
    log_info "Installing Node $NODE_VERSION via nvm..."
    export NVM_DIR="$HOME/.config/nvm"
    local nounset_was_on=0
    [[ $- == *u* ]] && nounset_was_on=1
    set +u
    source "$(brew --prefix nvm)/nvm.sh" --no-use
    nvm install "$NODE_VERSION"
    nvm alias default "$NODE_VERSION"
    [[ $nounset_was_on == 1 ]] && set -u
    log_success "Node $NODE_VERSION is the nvm default"
}

apply_macos_defaults() {
    log_info "Applying macOS defaults..."
    defaults write -g KeyRepeat -int 0
    defaults write -g InitialKeyRepeat -int 10
    log_success "Key repeat set to fastest"
}

print_next_steps() {
    echo ""
    log_success "╔══════════════════════════════════════════════════════════════╗"
    log_success "║                    Installation Complete!                    ║"
    log_success "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    log_info "Next Steps:"
    echo ""
    echo "  1. Start a new shell:            exec zsh"
    echo "  2. Validate:                     $SCRIPT_DIR/test-dotfiles.sh"
    echo "  3. Sign in to GitHub:            gh auth login"
    echo "  4. iTerm2 > Install Shell Integration (writes ~/.config/zsh/.iterm2_shell_integration.zsh)"
    echo "  5. Start services if wanted:     brew services start postgresql@17 redis"
    echo "  6. Log out and back in for the key repeat change"
    echo ""
}

main() {
    print_header
    check_prerequisites
    install_homebrew
    create_directories
    install_brew_packages
    install_oh_my_zsh
    install_zsh_plugins
    capture_git_identity
    link_files
    write_git_identity
    install_ruby
    install_node
    apply_macos_defaults
    warn_legacy_files
    print_next_steps
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set -euo pipefail
    case "${1:-}" in
        --print-links) print_links ;;
        "") main ;;
        *) log_error "Unknown argument: $1"; exit 2 ;;
    esac
fi

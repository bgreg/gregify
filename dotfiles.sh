#!/usr/bin/env bash

set -e

VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

check_prerequisites() {
    log_info "Checking prerequisites..."

    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This script is designed for macOS only"
        exit 1
    fi

    log_success "Running on macOS"
}

install_homebrew() {
    if command -v brew &> /dev/null; then
        log_success "Homebrew already installed"
        return 0
    fi

    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    log_success "Homebrew installed"
}

create_xdg_structure() {
    log_info "Creating XDG Base Directory structure..."

    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/share"
    mkdir -p "$HOME/.cache"

    log_success "XDG directories created"
}

setup_zshenv() {
    log_info "Setting up ~/.zshenv..."

    if [[ -f "$HOME/.zshenv" ]]; then
        if grep -q "XDG_CONFIG_HOME" "$HOME/.zshenv"; then
            log_warning "~/.zshenv already configured for XDG"
            return 0
        else
            log_warning "~/.zshenv exists but not configured for XDG"
            cp "$HOME/.zshenv" "$HOME/.zshenv.backup.$(date +%Y%m%d_%H%M%S)"
            log_info "Backed up existing .zshenv"
        fi
    fi

    cat > "$HOME/.zshenv" << 'EOF'
# Set XDG Base Directory Specification early
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Set ZDOTDIR to use XDG-compliant config directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
EOF

    log_success "~/.zshenv created"
}

install_brew_packages() {
    log_info "Installing Homebrew packages..."

    local packages=(
        # Core development tools
        "git"
        "gh"
        "fzf"
        "ripgrep"
        "tree"

        # Editors
        "neovim"
        "vim"

        # Version managers
        "nvm"
        "rbenv"
        "ruby-build"

        # Databases
        "postgresql@14"
        "redis"
        "meilisearch"

        # Utilities
        "figlet"
        "duti"
        "ical-buddy"
        "reminders-cli"
        "coreutils"
    )

    for package in "${packages[@]}"; do
        if brew list --formula | grep -q "^${package}$"; then
            log_success "$package already installed"
        else
            log_info "Installing $package..."
            brew install "$package" || log_warning "Failed to install $package"
        fi
    done

    log_success "Homebrew packages installation complete"
}

setup_zsh_config() {
    log_info "Setting up zsh configuration..."

    mkdir -p "$HOME/.config/zsh"

    if [[ ! -f "$HOME/.config/zsh/.zprofile" ]]; then
        cat > "$HOME/.config/zsh/.zprofile" << 'EOF'
# Initialize Homebrew environment
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi
EOF
        log_success "Created ~/.config/zsh/.zprofile"
    else
        log_warning "~/.config/zsh/.zprofile already exists"
    fi
}

install_oh_my_zsh() {
    local ZSH_DIR="$HOME/.config/oh-my-zsh"

    if [[ -d "$ZSH_DIR" ]]; then
        log_success "Oh My Zsh already installed at $ZSH_DIR"
        return 0
    fi

    log_info "Installing Oh My Zsh to XDG location..."

    export ZSH="$ZSH_DIR"
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    log_success "Oh My Zsh installed"
}

setup_nvm() {
    local NVM_DIR="$HOME/.config/nvm"

    if [[ -d "$NVM_DIR" ]]; then
        log_success "NVM directory already exists"
        return 0
    fi

    log_info "Setting up NVM directory..."
    mkdir -p "$NVM_DIR"

    log_success "NVM directory created"
    log_info "NVM will be initialized via Homebrew installation"
}

setup_rbenv() {
    local RBENV_ROOT="$HOME/.config/rbenv"

    if [[ -d "$RBENV_ROOT" ]]; then
        log_success "rbenv directory already exists"
        return 0
    fi

    log_info "Setting up rbenv directory..."
    mkdir -p "$RBENV_ROOT"

    log_success "rbenv directory created"
}

restore_config_prompt() {
    echo ""
    log_info "╔══════════════════════════════════════════════════════════════╗"
    log_info "║                  Configuration Restoration                   ║"
    log_info "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    log_warning "To complete the setup, restore your backed-up configuration:"
    echo ""
    echo "  1. Copy your backed-up ~/.config directory contents:"
    echo "     rsync -av /path/to/backup/.config/ ~/.config/"
    echo ""
    echo "  2. Or manually copy specific configs:"
    echo "     - ~/.config/zsh/.zshrc"
    echo "     - ~/.config/zsh/aliases"
    echo "     - ~/.config/zsh/functions"
    echo "     - ~/.config/nvim/"
    echo "     - ~/.config/git/"
    echo ""
    log_info "After restoring, run: ./test-dotfiles.sh to validate"
    echo ""
}

cleanup_old_files() {
    log_info "Checking for old configuration files to clean up..."

    local old_files=(
        "$HOME/.zshrc"
        "$HOME/.bash_profile"
        "$HOME/.bashrc"
    )

    for file in "${old_files[@]}"; do
        if [[ -f "$file" ]] && [[ ! -L "$file" ]]; then
            log_warning "Found old config: $file"
            echo "  Consider backing up and removing after verifying new setup works"
        fi
    done
}

print_next_steps() {
    echo ""
    log_success "╔══════════════════════════════════════════════════════════════╗"
    log_success "║                    Installation Complete!                    ║"
    log_success "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    log_info "Next Steps:"
    echo ""
    echo "  1. Restore your configuration files (see above)"
    echo "  2. Start a new shell session:"
    echo "     exec zsh"
    echo ""
    echo "  3. Verify installation:"
    echo "     ~/.config/test-dotfiles.sh"
    echo ""
    echo "  4. Install Node.js via NVM:"
    echo "     nvm install --lts"
    echo ""
    echo "  5. Install Ruby via rbenv:"
    echo "     rbenv install 3.3.0"
    echo "     rbenv global 3.3.0"
    echo ""
    log_info "For more information, see: ~/.config/README.md"
    echo ""
}

main() {
    print_header

    check_prerequisites
    install_homebrew
    create_xdg_structure
    setup_zshenv
    install_brew_packages
    setup_zsh_config
    install_oh_my_zsh
    setup_nvm
    setup_rbenv
    cleanup_old_files
    restore_config_prompt
    print_next_steps
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

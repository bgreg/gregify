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

main() {
    print_header
    link_files
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set -euo pipefail
    case "${1:-}" in
        --print-links) print_links ;;
        "") main ;;
        *) log_error "Unknown argument: $1"; exit 2 ;;
    esac
fi

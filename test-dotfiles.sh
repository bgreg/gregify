#!/usr/bin/env bash

VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0
TESTS_WARNING=0

log_test_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((TESTS_PASSED++))
}

log_test_fail() {
    echo -e "${RED}✗${NC} $1"
    ((TESTS_FAILED++))
}

log_test_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((TESTS_WARNING++))
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_header() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║       Development Environment Validation v${VERSION}              ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
}

print_section() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  $1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

test_xdg_environment() {
    print_section "XDG Base Directory Specification"

    if [[ -n "$XDG_CONFIG_HOME" && "$XDG_CONFIG_HOME" == "$HOME/.config" ]]; then
        log_test_pass "XDG_CONFIG_HOME is set correctly: $XDG_CONFIG_HOME"
    else
        log_test_fail "XDG_CONFIG_HOME not set or incorrect"
    fi

    if [[ -n "$XDG_DATA_HOME" && "$XDG_DATA_HOME" == "$HOME/.local/share" ]]; then
        log_test_pass "XDG_DATA_HOME is set correctly: $XDG_DATA_HOME"
    else
        log_test_fail "XDG_DATA_HOME not set or incorrect"
    fi

    if [[ -n "$XDG_CACHE_HOME" && "$XDG_CACHE_HOME" == "$HOME/.cache" ]]; then
        log_test_pass "XDG_CACHE_HOME is set correctly: $XDG_CACHE_HOME"
    else
        log_test_fail "XDG_CACHE_HOME not set or incorrect"
    fi

    if [[ -n "$ZDOTDIR" && "$ZDOTDIR" == "$HOME/.config/zsh" ]]; then
        log_test_pass "ZDOTDIR is set correctly: $ZDOTDIR"
    else
        log_test_fail "ZDOTDIR not set or incorrect"
    fi
}

test_directory_structure() {
    print_section "Directory Structure"

    local required_dirs=(
        "$HOME/.config"
        "$HOME/.local/share"
        "$HOME/.cache"
        "$HOME/.config/zsh"
        "$HOME/.config/oh-my-zsh"
    )

    for dir in "${required_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            log_test_pass "Directory exists: $dir"
        else
            log_test_fail "Directory missing: $dir"
        fi
    done
}

test_zsh_files() {
    print_section "Zsh Configuration Files"

    if [[ -f "$HOME/.zshenv" ]]; then
        log_test_pass "~/.zshenv exists"

        if grep -q "XDG_CONFIG_HOME" "$HOME/.zshenv"; then
            log_test_pass "~/.zshenv sets XDG variables"
        else
            log_test_fail "~/.zshenv missing XDG variables"
        fi
    else
        log_test_fail "~/.zshenv missing"
    fi

    if [[ -f "$HOME/.config/zsh/.zprofile" ]]; then
        log_test_pass "~/.config/zsh/.zprofile exists"
    else
        log_test_warn "~/.config/zsh/.zprofile missing (optional)"
    fi

    if [[ -f "$HOME/.config/zsh/.zshrc" ]]; then
        log_test_pass "~/.config/zsh/.zshrc exists"
    else
        log_test_fail "~/.config/zsh/.zshrc missing"
    fi

    if [[ -f "$HOME/.config/zsh/aliases" ]]; then
        log_test_pass "~/.config/zsh/aliases exists"
    else
        log_test_warn "~/.config/zsh/aliases missing"
    fi

    if [[ -f "$HOME/.config/zsh/functions" ]]; then
        log_test_pass "~/.config/zsh/functions exists"
    else
        log_test_warn "~/.config/zsh/functions missing"
    fi

    if [[ -f "$HOME/.zshrc" ]]; then
        log_test_warn "Old ~/.zshrc still exists (should be removed)"
    fi
}

test_homebrew() {
    print_section "Homebrew"

    if command -v brew &> /dev/null; then
        log_test_pass "Homebrew is installed"
        local brew_version=$(brew --version | head -n1)
        log_info "Version: $brew_version"
    else
        log_test_fail "Homebrew not found"
    fi
}

test_core_tools() {
    print_section "Core Development Tools"

    local tools=(
        "git:Git"
        "gh:GitHub CLI"
        "fzf:Fuzzy Finder"
        "rg:Ripgrep"
        "tree:Tree"
        "nvim:Neovim"
        "vim:Vim"
    )

    for tool_pair in "${tools[@]}"; do
        IFS=':' read -r cmd name <<< "$tool_pair"
        if command -v "$cmd" &> /dev/null; then
            log_test_pass "$name is installed"
        else
            log_test_fail "$name not found"
        fi
    done
}

test_version_managers() {
    print_section "Version Managers"

    if command -v nvm &> /dev/null || [[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ]]; then
        log_test_pass "NVM is available"
    else
        log_test_fail "NVM not found"
    fi

    if [[ -d "$HOME/.config/nvm" ]]; then
        log_test_pass "NVM directory at XDG location"
    else
        log_test_warn "NVM directory not at XDG location"
    fi

    if command -v rbenv &> /dev/null; then
        log_test_pass "rbenv is installed"

        if [[ -n "$RBENV_ROOT" && "$RBENV_ROOT" == "$HOME/.config/rbenv" ]]; then
            log_test_pass "RBENV_ROOT is set to XDG location"
        else
            log_test_warn "RBENV_ROOT not set to XDG location"
        fi
    else
        log_test_fail "rbenv not found"
    fi
}

test_oh_my_zsh() {
    print_section "Oh My Zsh"

    if [[ -d "$HOME/.config/oh-my-zsh" ]]; then
        log_test_pass "Oh My Zsh installed at XDG location"

        if [[ -f "$HOME/.config/oh-my-zsh/oh-my-zsh.sh" ]]; then
            log_test_pass "oh-my-zsh.sh exists"
        else
            log_test_fail "oh-my-zsh.sh missing"
        fi
    else
        log_test_fail "Oh My Zsh not found at XDG location"
    fi

    if [[ -n "$ZSH" && "$ZSH" == "$HOME/.config/oh-my-zsh" ]]; then
        log_test_pass "ZSH environment variable set correctly"
    else
        log_test_warn "ZSH environment variable not set (may need to reload shell)"
    fi

    if command -v omz &> /dev/null; then
        log_test_pass "omz command is available"
    else
        log_test_warn "omz command not found (may need to reload shell)"
    fi
}

test_databases() {
    print_section "Databases & Services"

    local services=(
        "postgres:PostgreSQL"
        "redis-cli:Redis"
        "meilisearch:MeiliSearch"
    )

    for service_pair in "${services[@]}"; do
        IFS=':' read -r cmd name <<< "$service_pair"
        if command -v "$cmd" &> /dev/null; then
            log_test_pass "$name is installed"
        else
            log_test_warn "$name not found (optional)"
        fi
    done
}

test_custom_scripts() {
    print_section "Custom Scripts"

    local scripts=(
        "goodmorning.sh"
        "rem-add.sh"
        "cal-today.sh"
        "backup_dev_env.sh"
    )

    for script in "${scripts[@]}"; do
        if [[ -f "$HOME/.config/zsh/scripts/$script" ]]; then
            log_test_pass "$script exists"
        else
            log_test_warn "$script missing (optional)"
        fi
    done
}

test_shell_integration() {
    print_section "Shell Integration Test"

    log_info "Testing zsh can load configuration..."

    local test_output=$(zsh -l -c 'echo "Shell loaded successfully"' 2>&1)

    if [[ "$test_output" == *"Shell loaded successfully"* ]]; then
        log_test_pass "Zsh loads configuration without errors"
    else
        log_test_fail "Zsh configuration has errors"
        echo "$test_output" | head -5
    fi

    if zsh -c 'source "$ZDOTDIR/.zshrc" 2>&1' | grep -q "command not found"; then
        log_test_warn "Some commands in .zshrc not found (may be normal)"
    fi
}

test_git_config() {
    print_section "Git Configuration"

    if [[ -f "$HOME/.config/git/config" ]] || [[ -f "$HOME/.gitconfig" ]]; then
        log_test_pass "Git config exists"
    else
        log_test_warn "Git config not found"
    fi

    if git config user.name &> /dev/null; then
        log_test_pass "Git user.name is set: $(git config user.name)"
    else
        log_test_warn "Git user.name not set"
    fi

    if git config user.email &> /dev/null; then
        log_test_pass "Git user.email is set: $(git config user.email)"
    else
        log_test_warn "Git user.email not set"
    fi
}

print_summary() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                        Test Summary                          ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    echo -e "${GREEN}Passed:${NC}  $TESTS_PASSED"
    echo -e "${YELLOW}Warnings:${NC} $TESTS_WARNING"
    echo -e "${RED}Failed:${NC}  $TESTS_FAILED"
    echo ""

    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}✓ Environment setup is complete and working!${NC}"
        echo ""
        return 0
    elif [[ $TESTS_FAILED -le 3 ]]; then
        echo -e "${YELLOW}⚠ Environment mostly working, but has some issues${NC}"
        echo ""
        return 1
    else
        echo -e "${RED}✗ Environment has significant issues${NC}"
        echo ""
        return 2
    fi
}

main() {
    print_header

    test_xdg_environment
    test_directory_structure
    test_zsh_files
    test_homebrew
    test_core_tools
    test_version_managers
    test_oh_my_zsh
    test_databases
    test_custom_scripts
    test_shell_integration
    test_git_config

    print_summary
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
    exit $?
fi

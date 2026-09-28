#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dotfiles.sh"

TESTS_PASSED=0
TESTS_FAILED=0
TESTS_WARNING=0

log_test_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((++TESTS_PASSED))
}

log_test_fail() {
    echo -e "${RED}✗${NC} $1"
    ((++TESTS_FAILED))
}

log_test_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((++TESTS_WARNING))
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

    if [[ "${XDG_CONFIG_HOME:-}" == "$HOME/.config" ]]; then
        log_test_pass "XDG_CONFIG_HOME is set correctly: $XDG_CONFIG_HOME"
    else
        log_test_fail "XDG_CONFIG_HOME not set or incorrect"
    fi

    if [[ "${XDG_DATA_HOME:-}" == "$HOME/.local/share" ]]; then
        log_test_pass "XDG_DATA_HOME is set correctly: $XDG_DATA_HOME"
    else
        log_test_fail "XDG_DATA_HOME not set or incorrect"
    fi

    if [[ "${XDG_CACHE_HOME:-}" == "$HOME/.cache" ]]; then
        log_test_pass "XDG_CACHE_HOME is set correctly: $XDG_CACHE_HOME"
    else
        log_test_fail "XDG_CACHE_HOME not set or incorrect"
    fi

    if [[ "${ZDOTDIR:-}" == "$HOME/.config/zsh" ]]; then
        log_test_pass "ZDOTDIR is set correctly: $ZDOTDIR"
    else
        log_test_fail "ZDOTDIR not set or incorrect"
    fi
}

test_directory_structure() {
    print_section "Directory Structure"

    local dir
    for dir in "$HOME/.config" "$HOME/.local/share" "$HOME/.cache" "$HOME/.config/zsh" "$HOME/.config/oh-my-zsh" "$HOME/bin"; do
        if [[ -d "$dir" ]]; then
            log_test_pass "Directory exists: $dir"
        else
            log_test_fail "Directory missing: $dir"
        fi
    done
}

test_symlinks() {
    print_section "Symlinks"

    local entry src dst
    for entry in "${LINKS[@]}"; do
        src="$SCRIPT_DIR/${entry%%:*}"
        dst="$HOME/${entry#*:}"
        if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
            log_test_pass "${entry#*:} -> ${entry%%:*}"
        else
            log_test_fail "${entry#*:} is not linked to ${entry%%:*}"
        fi
    done
}

test_homebrew() {
    print_section "Homebrew"

    if ! command -v brew &> /dev/null; then
        log_test_fail "Homebrew not found"
        return
    fi
    log_test_pass "Homebrew is installed: $(brew --version | head -n1)"

    local output
    if output="$(brew bundle check --no-upgrade --verbose --file="$SCRIPT_DIR/Brewfile" 2>&1)"; then
        log_test_pass "Brewfile dependencies are satisfied"
    else
        log_test_fail "Brewfile has unsatisfied entries"
        echo "$output" | grep '→'
    fi
}

test_version_managers() {
    print_section "Version Managers"

    if command -v rbenv &> /dev/null; then
        log_test_pass "rbenv is installed"
        local ruby_global
        ruby_global="$(rbenv global 2>/dev/null)"
        if [[ "$ruby_global" == "$RUBY_VERSION" ]]; then
            log_test_pass "rbenv global is $RUBY_VERSION"
        else
            log_test_fail "rbenv global is '$ruby_global', expected $RUBY_VERSION"
        fi
    else
        log_test_fail "rbenv not found (expected global Ruby $RUBY_VERSION)"
    fi

    if [[ "${RBENV_ROOT:-}" == "$HOME/.config/rbenv" ]]; then
        log_test_pass "RBENV_ROOT is at the XDG location"
    else
        log_test_warn "RBENV_ROOT is not $HOME/.config/rbenv (reload the shell)"
    fi

    local nvm_sh="$BREW_PREFIX/opt/nvm/nvm.sh"
    if [[ -s "$nvm_sh" ]]; then
        log_test_pass "nvm is installed"
    else
        log_test_fail "nvm.sh not found at $nvm_sh"
    fi

    local node_default="$HOME/.config/nvm/alias/default"
    if [[ -f "$node_default" && "$(cat "$node_default")" == "$NODE_VERSION" ]]; then
        log_test_pass "nvm default alias is $NODE_VERSION"
    else
        log_test_fail "nvm default alias is not $NODE_VERSION (expected in $node_default)"
    fi

    if [[ "${NVM_DIR:-}" == "$HOME/.config/nvm" ]]; then
        log_test_pass "NVM_DIR is at the XDG location"
    else
        log_test_warn "NVM_DIR is not $HOME/.config/nvm (reload the shell)"
    fi
}

test_oh_my_zsh() {
    print_section "Oh My Zsh"

    local omz="$HOME/.config/oh-my-zsh"
    if [[ -f "$omz/oh-my-zsh.sh" ]]; then
        log_test_pass "oh-my-zsh.sh exists at the XDG location"
    else
        log_test_fail "oh-my-zsh.sh missing from $omz"
    fi

    local plugin
    for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
        if [[ -f "$omz/custom/plugins/$plugin/$plugin.zsh" ]]; then
            log_test_pass "$plugin is installed"
        else
            log_test_fail "$plugin missing from $omz/custom/plugins"
        fi
    done

    if [[ -f "$omz/custom/plugins/tips/tips.plugin.zsh" ]]; then
        log_test_pass "tips plugin is linked"
    else
        log_test_fail "tips plugin missing"
    fi

    if [[ "${ZSH:-}" == "$omz" ]]; then
        log_test_pass "ZSH environment variable set correctly"
    else
        log_test_warn "ZSH environment variable not set (reload the shell)"
    fi
}

test_custom_scripts() {
    print_section "Custom Scripts"

    local entry dst
    for entry in "${LINKS[@]}"; do
        dst="${entry#*:}"
        case "$dst" in
            .config/zsh/scripts/*|bin/*)
                if [[ -x "$HOME/$dst" ]]; then
                    log_test_pass "$dst is executable"
                else
                    log_test_fail "$dst is missing or not executable"
                fi
                ;;
        esac
    done
}

test_shell_integration() {
    print_section "Shell Integration"

    local probe='type load-nvmrc; alias vim'
    local stderr stdout
    stderr="$(zsh -li -c "$probe" 2>&1 >/dev/null | grep -v "can't change option: zle" || true)"
    stdout="$(zsh -li -c "$probe" 2>/dev/null)"

    if [[ -z "$stderr" ]]; then
        log_test_pass "Interactive login zsh starts without errors"
    else
        log_test_fail "Interactive login zsh wrote to stderr:"
        echo "$stderr" | head -5
    fi

    if [[ "$stdout" == *"load-nvmrc is a shell function"* ]]; then
        log_test_pass "functions.zsh is loaded (load-nvmrc defined)"
    else
        log_test_fail "load-nvmrc is not defined; functions.zsh did not load"
    fi

    if [[ "$stdout" == *"vim=nvim-profile"* ]]; then
        log_test_pass "aliases.zsh is loaded (vim -> nvim-profile)"
    else
        log_test_fail "vim alias missing; aliases.zsh did not load"
    fi
}

test_git_config() {
    print_section "Git Configuration"

    local local_file="$HOME/.config/git/config.local"
    if [[ -f "$local_file" ]]; then
        local name email
        name="$(git config --file "$local_file" user.name 2>/dev/null)"
        email="$(git config --file "$local_file" user.email 2>/dev/null)"
        if [[ -n "$name" && -n "$email" ]]; then
            log_test_pass "config.local identity: $name <$email>"
        else
            log_test_fail "config.local exists but user.name or user.email is empty"
        fi
    else
        log_test_fail "config.local missing at $local_file"
    fi

    if [[ "$(git config --global filter.lfs.required 2>/dev/null)" == "true" ]] && ! command -v git-lfs &> /dev/null; then
        log_test_warn "filter.lfs.required is true but git-lfs is not installed"
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
    test_symlinks
    test_homebrew
    test_version_managers
    test_oh_my_zsh
    test_custom_scripts
    test_shell_integration
    test_git_config

    print_summary
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
    exit $?
fi

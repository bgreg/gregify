#!/usr/bin/env bash

REPO="$HOME/Personal/gregify"
FAILURES=0

pass() { echo "PASS $1"; }
fail() { echo "FAIL $1"; FAILURES=$((FAILURES + 1)); }

check_links() {
    local src dst target
    while IFS=$'\t' read -r src dst; do
        if [[ ! -L "$HOME/$dst" ]]; then
            fail "$dst is not a symlink"
            continue
        fi
        target="$(readlink -f "$HOME/$dst")"
        if [[ "$target" == "$REPO/$src" && -e "$target" ]]; then
            pass "$dst -> $src"
        else
            fail "$dst resolves to '$target'"
        fi
    done < <("$REPO/dotfiles.sh" --print-links)
}

check_oh_my_zsh() {
    local omz="$HOME/.config/oh-my-zsh"
    local f
    for f in oh-my-zsh.sh custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh custom/plugins/tips/tips.plugin.zsh; do
        if [[ -f "$omz/$f" ]]; then pass "omz $f"; else fail "omz $f missing"; fi
    done
}

check_brew_bundle() {
    if brew bundle check --no-upgrade --file="$REPO/Brewfile" > /tmp/bundle-check.log 2>&1; then
        pass "brew bundle check"
    else
        fail "brew bundle check: $(tr '\n' ' ' < /tmp/bundle-check.log)"
    fi
    local formula installed
    installed="$(brew list --formula --full-name)"
    while read -r formula; do
        case " ${HOMEBREW_BUNDLE_BREW_SKIP:-} " in
            *" $formula "*) continue ;;
        esac
        if grep -qx "$formula" <<< "$installed" || grep -qx "${formula##*/}" <<< "$installed"; then
            pass "formula $formula installed"
        else
            fail "formula $formula not installed"
        fi
    done < <(sed -n 's/^brew "\([^"]*\)".*/\1/p' "$REPO/Brewfile")
}

check_tool_versions() {
    local tool
    for tool in git rg jq fzf nvim gh psql redis-cli; do
        if "$tool" --version > /dev/null 2>&1; then pass "$tool --version"; else fail "$tool --version"; fi
    done
    if tmux -V > /dev/null 2>&1; then pass "tmux -V"; else fail "tmux -V"; fi
}

check_interactive_zsh() {
    local probe='type load-nvmrc; type check-port; alias vim; print -r -- "ZSH=$ZSH"; ruby -v; node -v'
    local out err
    out="$(zsh -li -c "$probe" 2>/dev/null)"
    err="$(zsh -li -c "$probe" 2>&1 >/dev/null | grep -v "can't change option: zle")"
    [[ "$out" == *"load-nvmrc is a shell function"* ]] && pass "load-nvmrc defined" || fail "load-nvmrc missing"
    [[ "$out" == *"check-port is a shell function"* ]] && pass "check-port defined" || fail "check-port missing"
    [[ "$out" == *"vim=nvim-profile"* ]] && pass "vim alias" || fail "vim alias missing"
    [[ "$out" == *"ZSH=$HOME/.config/oh-my-zsh"* ]] && pass "ZSH points at XDG oh-my-zsh" || fail "ZSH is wrong"
    [[ "$out" == *"ruby 3.3.6"* ]] && pass "ruby 3.3.6" || fail "ruby version: $(grep -m1 '^ruby' <<< "$out")"
    [[ "$out" == *"v22.18.0"* ]] && pass "node v22.18.0" || fail "node version: $(grep -m1 '^v' <<< "$out")"
    if [[ -z "$err" ]]; then pass "interactive zsh stderr clean"; else fail "interactive zsh stderr: $(head -3 <<< "$err" | tr '\n' ' ')"; fi
}

check_neovim() {
    if GIT_CONFIG_GLOBAL=/dev/null nvim --headless "+Lazy! restore" +qa > /tmp/lazy.log 2>&1 && ! grep -qE 'E5113|Error in|Not an editor command' /tmp/lazy.log; then
        pass "nvim Lazy restore"
    else
        fail "nvim Lazy restore: $(tail -3 /tmp/lazy.log | tr '\n' ' ')"
    fi
    if [[ -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]]; then pass "lazy.nvim present"; else fail "lazy.nvim missing"; fi
}

check_git_config() {
    local hooks
    [[ "$(git config user.name)" == "E2E Tester" ]] && pass "git user.name" || fail "git user.name: $(git config user.name)"
    [[ "$(git config include.path)" == "config.local" ]] && pass "git include.path" || fail "git include.path: $(git config include.path)"
    hooks="$(git config --path core.hooksPath)"
    if [[ -d "$hooks" && -f "$hooks/pre-push" ]]; then pass "core.hooksPath -> $hooks"; else fail "core.hooksPath '$hooks' has no pre-push"; fi
}

check_defaults_log() {
    grep -qx 'write -g KeyRepeat -int 0' /tmp/defaults.log && pass "defaults KeyRepeat" || fail "defaults KeyRepeat not written"
    grep -qx 'write -g InitialKeyRepeat -int 10' /tmp/defaults.log && pass "defaults InitialKeyRepeat" || fail "defaults InitialKeyRepeat not written"
}

check_idempotent() {
    local before after
    before="$(find "$HOME" -name '*.backup.*' 2>/dev/null | wc -l)"
    if OSTYPE=darwin24.0 bash "$REPO/dotfiles.sh" > /tmp/second-run.log 2>&1; then pass "second install run exits 0"; else fail "second install run failed: $(tail -3 /tmp/second-run.log | tr '\n' ' ')"; fi
    after="$(find "$HOME" -name '*.backup.*' 2>/dev/null | wc -l)"
    [[ "$before" == "$after" ]] && pass "second run created no backups" || fail "second run created backups: $before -> $after"
}

check_links
check_oh_my_zsh
check_brew_bundle
check_tool_versions
check_interactive_zsh
check_neovim
check_git_config
check_defaults_log
check_idempotent

echo "inspect: $FAILURES failure(s)"
exit "$FAILURES"

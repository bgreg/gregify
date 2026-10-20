Describe 'dotfiles.sh main with faked tools'
  Include ./dotfiles.sh

  setup() {
    TMP="$(mktemp -d)"
    HOME="$TMP/home"
    XDG_CONFIG_HOME="$TMP/home/.config"
    BREW_PREFIX="$TMP/brew"
    LOG="$TMP/calls.log"
    REAL_GIT="$(command -v git)"
    mkdir -p "$HOME" "$TMP/bin" "$BREW_PREFIX/bin" "$TMP/nvm"
    export HOME XDG_CONFIG_HOME BREW_PREFIX LOG REAL_GIT
    export GIT_AUTHOR_NAME='E2E Tester' GIT_AUTHOR_EMAIL='e2e@example.com'
    OSTYPE=darwin25.0

    cat > "$BREW_PREFIX/bin/brew" <<EOF
#!/usr/bin/env bash
echo "brew \$*" >> "$LOG"
case "\$1" in
  shellenv) exit 0 ;;
  --prefix) echo "$TMP/nvm" ;;
esac
EOF
    cat > "$TMP/nvm/nvm.sh" <<EOF
nvm() { echo "nvm \$*" >> "$LOG"; }
EOF
    cat > "$TMP/bin/git" <<EOF
#!/usr/bin/env bash
if [[ "\$1" == "config" ]]; then exec "$REAL_GIT" "\$@"; fi
echo "git \$*" >> "$LOG"
if [[ "\$1" == "clone" ]]; then
  if [[ -e "\${@: -1}" ]]; then echo "fatal: destination path '\${@: -1}' already exists" >&2; exit 128; fi
  mkdir -p "\${@: -1}"; touch "\${@: -1}/oh-my-zsh.sh"
fi
EOF
    cat > "$TMP/bin/rbenv" <<EOF
#!/usr/bin/env bash
echo "rbenv \$*" >> "$LOG"
EOF
    cat > "$TMP/bin/defaults" <<EOF
#!/usr/bin/env bash
echo "defaults \$*" >> "$LOG"
EOF
    cat > "$TMP/bin/codium" <<EOF
#!/usr/bin/env bash
echo "codium \$*" >> "$LOG"
if [[ "\$1" == "--list-extensions" ]]; then printf 'already.installed\n'; fi
EOF
    chmod +x "$BREW_PREFIX/bin/brew" "$TMP/bin/git" "$TMP/bin/rbenv" "$TMP/bin/defaults" "$TMP/bin/codium"
    PATH="$TMP/bin:$BREW_PREFIX/bin:$PATH"
    export PATH
  }
  BeforeEach 'setup'

  It 'runs every step against a fresh home'
    When run main
    The status should be success
    The output should include 'Installation Complete'
    The contents of file "$LOG" should include "brew bundle install --no-upgrade --file=$SCRIPT_DIR/Brewfile"
    The contents of file "$LOG" should include "git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git $HOME/.config/oh-my-zsh"
    The contents of file "$LOG" should include "git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.config/oh-my-zsh/custom/plugins/zsh-autosuggestions"
    The contents of file "$LOG" should include "git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.config/oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    The contents of file "$LOG" should include 'rbenv install --skip-existing 3.3.6'
    The contents of file "$LOG" should include 'rbenv global 3.3.6'
    The contents of file "$LOG" should include 'nvm install 22.18.0'
    The contents of file "$LOG" should include 'nvm alias default 22.18.0'
    The contents of file "$LOG" should include 'defaults write -g KeyRepeat -int 0'
    The contents of file "$LOG" should include 'defaults write -g InitialKeyRepeat -int 10'
    The path "$HOME/.config/nvm" should be directory
    The path "$HOME/.config/rbenv" should be directory
    The value "$(readlink "$HOME/.zshenv")" should equal "$SCRIPT_DIR/home/.zshenv"
    The value "$(git config --file "$HOME/.config/git/config.local" user.email)" should equal 'e2e@example.com'
  End

  It 'is idempotent: a second run creates no new backups'
    printf 'pre-existing\n' > "$HOME/.zshenv"
    main > /dev/null
    first="$(find "$HOME" -name '*.backup.*' | wc -l | tr -d ' ')"
    When run main
    The status should be success
    The output should include 'Already linked'
    The output should not include 'Backed up'
    The value "$first" should equal 1
    The value "$(find "$HOME" -name '*.backup.*' | wc -l | tr -d ' ')" should equal 1
  End

  It 'captures the git identity before linking replaces the global config'
    unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL
    mkdir -p "$HOME/.config/git"
    printf '[user]\n\tname = Pre Link\n\temail = prelink@example.com\n' > "$HOME/.config/git/config"
    When run main
    The status should be success
    The output should include 'Wrote git identity'
    The value "$(git config --file "$HOME/.config/git/config.local" user.name)" should equal 'Pre Link'
    The value "$(git config --file "$HOME/.config/git/config.local" user.email)" should equal 'prelink@example.com'
  End

  It 'clones oh-my-zsh before linking custom files into it'
    When run main
    The status should be success
    The output should include 'Oh My Zsh installed'
    The stderr should not include 'already exists'
    The value "$(readlink "$HOME/.config/oh-my-zsh/custom/aliases.zsh")" should equal "$SCRIPT_DIR/config/oh-my-zsh/custom/aliases.zsh"
    The path "$HOME/.config/oh-my-zsh/oh-my-zsh.sh" should be file
  End

  It 'installs only the extensions that are missing'
    printf 'already.installed\nneeds.install\n' > "$TMP/extensions.txt"
    SCRIPT_DIR_EXTENSIONS="$TMP/extensions.txt"
    When run main
    The status should be success
    The output should include 'Installing needs.install'
    The contents of file "$LOG" should include 'codium --install-extension needs.install'
    The contents of file "$LOG" should not include 'codium --install-extension already.installed'
  End

  It 'warns and continues when codium is absent'
    mv "$TMP/bin/codium" "$TMP/bin/codium.hidden"
    PATH="$TMP/bin:$BREW_PREFIX/bin:/usr/bin:/bin"
    When run main
    The status should be success
    The output should include 'codium is not on PATH'
    The output should include 'Installation Complete'
  End
End

Describe 'test-dotfiles.sh sections'
  Include ./test-dotfiles.sh

  setup() {
    TMP="$(mktemp -d)"
    HOME="$TMP/home"
    export HOME
    mkdir -p "$HOME"
    TESTS_PASSED=0
    TESTS_FAILED=0
    TESTS_WARNING=0
  }
  BeforeEach 'setup'

  Describe 'test_symlinks'
    It 'passes for every entry after link_files'
      link_files > /dev/null
      When call test_symlinks
      The output should include 'Symlinks'
      The variable TESTS_FAILED should equal 0
      The variable TESTS_PASSED should equal 34
    End

    It 'fails for a destination that is a regular file'
      link_files > /dev/null
      mv "$HOME/.zshenv" "$HOME/.zshenv.gone"
      printf 'x\n' > "$HOME/.zshenv"
      When call test_symlinks
      The output should include 'not linked'
      The variable TESTS_FAILED should equal 1
      The variable TESTS_PASSED should equal 33
    End
  End

  Describe 'test_git_config'
    lfs_setup() {
      link_files > /dev/null
      printf '[user]\n\tname = Spec Name\n\temail = spec@example.com\n' > "$HOME/.config/git/config.local"
      XDG_CONFIG_HOME="$HOME/.config"
      export XDG_CONFIG_HOME
      mkdir -p "$TMP/bin"
      ln -s "$(command -v git)" "$TMP/bin/git"
    }

    It 'passes with a complete config.local and warns when the lfs filter is required but git-lfs is absent'
      lfs_setup
      PATH="$TMP/bin:/usr/bin:/bin"
      When call test_git_config
      The output should include 'Spec Name'
      The output should include 'git-lfs is not installed'
      The variable TESTS_FAILED should equal 0
      The variable TESTS_WARNING should equal 1
    End

    It 'does not warn when git-lfs is on PATH'
      lfs_setup
      printf '#!/bin/sh\nexit 0\n' > "$TMP/bin/git-lfs"
      chmod +x "$TMP/bin/git-lfs"
      PATH="$TMP/bin:/usr/bin:/bin"
      When call test_git_config
      The output should include 'Spec Name'
      The variable TESTS_FAILED should equal 0
      The variable TESTS_WARNING should equal 0
    End

    It 'fails when config.local is missing'
      link_files > /dev/null
      XDG_CONFIG_HOME="$HOME/.config"
      export XDG_CONFIG_HOME
      When call test_git_config
      The output should include 'config.local'
      The variable TESTS_FAILED should equal 1
    End
  End

  Describe 'test_custom_scripts'
    It 'checks the 14 scripts and 3 wrappers are executable'
      link_files > /dev/null
      When call test_custom_scripts
      The output should include 'Custom Scripts'
      The variable TESTS_FAILED should equal 0
      The variable TESTS_PASSED should equal 17
    End
  End

  Describe 'test_vscodium'
    It 'warns and does not fail when codium is not on PATH'
      PATH="$TMP/bin:/usr/bin:/bin"
      When call test_vscodium
      The output should include 'codium not on PATH'
      The variable TESTS_WARNING should equal 1
      The variable TESTS_FAILED should equal 0
    End
  End

  Describe 'test_version_managers'
    managers_setup() {
      BREW_PREFIX="$TMP/brew"
      mkdir -p "$TMP/bin" "$BREW_PREFIX/opt/nvm" "$HOME/.config/nvm/alias"
      printf 'nvm() { :; }\n' > "$BREW_PREFIX/opt/nvm/nvm.sh"
      printf '#!/bin/sh\n[ "$1" = global ] && echo 3.3.6\n' > "$TMP/bin/rbenv"
      chmod +x "$TMP/bin/rbenv"
      PATH="$TMP/bin:$PATH"
      unset RBENV_ROOT NVM_DIR
    }

    It 'passes when rbenv global and the nvm default alias match the pinned versions'
      managers_setup
      printf '22.18.0\n' > "$HOME/.config/nvm/alias/default"
      When call test_version_managers
      The output should include 'rbenv global is 3.3.6'
      The output should include 'nvm default alias is 22.18.0'
      The variable TESTS_FAILED should equal 0
      The variable TESTS_PASSED should equal 4
    End

    It 'fails once when the nvm default alias is a different version'
      managers_setup
      printf '20.0.0\n' > "$HOME/.config/nvm/alias/default"
      When call test_version_managers
      The output should include 'nvm default alias is not 22.18.0'
      The variable TESTS_FAILED should equal 1
      The variable TESTS_PASSED should equal 3
    End
  End
End

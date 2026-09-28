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
      The variable TESTS_PASSED should equal 31
    End

    It 'fails for a destination that is a regular file'
      link_files > /dev/null
      mv "$HOME/.zshenv" "$HOME/.zshenv.gone"
      printf 'x\n' > "$HOME/.zshenv"
      When call test_symlinks
      The output should include 'not linked'
      The variable TESTS_FAILED should equal 1
      The variable TESTS_PASSED should equal 30
    End
  End

  Describe 'test_git_config'
    It 'passes with a complete config.local and warns about git-lfs only when the filter is required'
      link_files > /dev/null
      printf '[user]\n\tname = Spec Name\n\temail = spec@example.com\n' > "$HOME/.config/git/config.local"
      XDG_CONFIG_HOME="$HOME/.config"
      export XDG_CONFIG_HOME
      When call test_git_config
      The output should include 'Spec Name'
      The variable TESTS_FAILED should equal 0
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

  Describe 'test_version_managers'
    It 'reads the pinned versions from dotfiles.sh'
      When call test_version_managers
      The output should include '3.3.6'
      The output should include '22.18.0'
    End
  End
End

Describe 'dotfiles.sh prerequisites and identity'
  Include ./dotfiles.sh

  setup() {
    TMP="$(mktemp -d)"
    HOME="$TMP/home"
    XDG_CONFIG_HOME="$TMP/home/.config"
    mkdir -p "$HOME/.config/git"
    export HOME XDG_CONFIG_HOME
    unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL
    unset GIT_CONFIG_GLOBAL GIT_CONFIG_PARAMETERS GIT_CONFIG_COUNT
  }
  BeforeEach 'setup'

  Describe 'check_prerequisites'
    It 'passes on darwin'
      OSTYPE=darwin25.0
      When run check_prerequisites
      The status should be success
      The output should include 'Running on macOS'
    End

    It 'exits 1 on anything else'
      OSTYPE=linux-gnu
      When run check_prerequisites
      The status should equal 1
      The output should include 'macOS only'
    End
  End

  Describe 'capture_git_identity'
    It 'reads the global git config'
      git config --global user.name 'Config Name'
      git config --global user.email 'config@example.com'
      When call capture_git_identity
      The variable GIT_IDENTITY_NAME should equal 'Config Name'
      The variable GIT_IDENTITY_EMAIL should equal 'config@example.com'
    End

    It 'falls back to GIT_AUTHOR_NAME and GIT_AUTHOR_EMAIL'
      export GIT_AUTHOR_NAME='Env Name' GIT_AUTHOR_EMAIL='env@example.com'
      When call capture_git_identity
      The variable GIT_IDENTITY_NAME should equal 'Env Name'
      The variable GIT_IDENTITY_EMAIL should equal 'env@example.com'
    End
  End

  Describe 'write_git_identity'
    It 'writes config.local from the captured identity'
      GIT_IDENTITY_NAME='Config Name'
      GIT_IDENTITY_EMAIL='config@example.com'
      When call write_git_identity
      The status should be success
      The output should include 'Wrote git identity'
      The value "$(git config --file "$HOME/.config/git/config.local" user.name)" should equal 'Config Name'
      The value "$(git config --file "$HOME/.config/git/config.local" user.email)" should equal 'config@example.com'
    End

    It 'leaves an existing config.local untouched'
      printf '[user]\n\tname = Keep Me\n\temail = keep@example.com\n' > "$HOME/.config/git/config.local"
      GIT_IDENTITY_NAME='Other'
      GIT_IDENTITY_EMAIL='other@example.com'
      When call write_git_identity
      The status should be success
      The output should include 'already present'
      The value "$(git config --file "$HOME/.config/git/config.local" user.name)" should equal 'Keep Me'
    End

    It 'replaces a config.local whose name and email are empty'
      printf '[user]\n\tname = \n\temail = \n' > "$HOME/.config/git/config.local"
      GIT_IDENTITY_NAME='Filled Name'
      GIT_IDENTITY_EMAIL='filled@example.com'
      Data ''
      When call write_git_identity
      The status should be success
      The output should include 'Wrote git identity'
      The value "$(git config --file "$HOME/.config/git/config.local" user.name)" should equal 'Filled Name'
      The value "$(git config --file "$HOME/.config/git/config.local" user.email)" should equal 'filled@example.com'
    End

    It 'writes an incomplete identity and warns when nothing is available'
      GIT_IDENTITY_NAME=''
      GIT_IDENTITY_EMAIL=''
      Data ''
      When call write_git_identity
      The status should be success
      The output should include 'incomplete'
      The path "$HOME/.config/git/config.local" should be file
    End
  End

  Describe 'warn_legacy_files'
    It 'warns for each regular legacy file and says nothing for symlinks or absent files'
      printf 'x\n' > "$HOME/.zshrc"
      ln -s "$TMP/nowhere" "$HOME/.bashrc"
      When call warn_legacy_files
      The status should be success
      The output should include "$HOME/.zshrc"
      The output should not include '.bashrc'
      The output should not include '.bash_profile'
    End
  End
End

Describe 'dotfiles.sh link core'
  Include ./dotfiles.sh

  setup() {
    TMP="$(mktemp -d)"
    mkdir -p "$TMP/repo/config/zsh"
    printf 'source\n' > "$TMP/repo/config/zsh/.zshrc"
  }
  BeforeEach 'setup'

  Describe 'link_path'
    It 'creates a symlink when the destination is absent'
      When call link_path "$TMP/repo/config/zsh/.zshrc" "$TMP/home/.config/zsh/.zshrc"
      The status should be success
      The output should include 'Linked'
      The path "$TMP/home/.config/zsh/.zshrc" should be symlink
      The value "$(readlink "$TMP/home/.config/zsh/.zshrc")" should equal "$TMP/repo/config/zsh/.zshrc"
    End

    It 'creates missing parent directories'
      When call link_path "$TMP/repo/config/zsh/.zshrc" "$TMP/home/bin/deep/nvim-profile"
      The status should be success
      The output should include 'Linked'
      The path "$TMP/home/bin/deep" should be directory
      The path "$TMP/home/bin/deep/nvim-profile" should be symlink
    End

    It 'reports already linked and changes nothing on a second call'
      link_path "$TMP/repo/config/zsh/.zshrc" "$TMP/home/.zshrc" > /dev/null
      When call link_path "$TMP/repo/config/zsh/.zshrc" "$TMP/home/.zshrc"
      The status should be success
      The output should include 'Already linked'
      The value "$(ls -A "$TMP/home" | wc -l | tr -d ' ')" should equal 1
    End

    It 'backs up an existing regular file before linking'
      mkdir -p "$TMP/home"
      printf 'old\n' > "$TMP/home/.zshrc"
      When call link_path "$TMP/repo/config/zsh/.zshrc" "$TMP/home/.zshrc"
      The status should be success
      The output should include 'Backed up'
      The path "$TMP/home/.zshrc" should be symlink
      The contents of file "$TMP/home/.zshrc.$BACKUP_SUFFIX" should include 'old'
    End

    It 'backs up a symlink that points elsewhere'
      mkdir -p "$TMP/home" "$TMP/elsewhere"
      printf 'other\n' > "$TMP/elsewhere/file"
      ln -s "$TMP/elsewhere/file" "$TMP/home/.zshrc"
      When call link_path "$TMP/repo/config/zsh/.zshrc" "$TMP/home/.zshrc"
      The status should be success
      The output should include 'Backed up'
      The value "$(readlink "$TMP/home/.zshrc")" should equal "$TMP/repo/config/zsh/.zshrc"
      The value "$(readlink "$TMP/home/.zshrc.$BACKUP_SUFFIX")" should equal "$TMP/elsewhere/file"
      The contents of file "$TMP/elsewhere/file" should include 'other'
    End

    It 'backs up an existing directory before linking'
      mkdir -p "$TMP/home/.config/nvim"
      printf 'old\n' > "$TMP/home/.config/nvim/init.lua"
      mkdir -p "$TMP/repo/config/nvim"
      printf 'new\n' > "$TMP/repo/config/nvim/init.lua"
      When call link_path "$TMP/repo/config/nvim" "$TMP/home/.config/nvim"
      The status should be success
      The output should include 'Backed up'
      The path "$TMP/home/.config/nvim" should be symlink
      The contents of file "$TMP/home/.config/nvim/init.lua" should include 'new'
      The contents of file "$TMP/home/.config/nvim.$BACKUP_SUFFIX/init.lua" should include 'old'
      The path "$TMP/home/.config/nvim/nvim" should not be exist
    End

    It 'refuses a missing source'
      When call link_path "$TMP/repo/config/zsh/missing" "$TMP/home/.missing"
      The status should be failure
      The output should include 'Missing link source'
      The path "$TMP/home/.missing" should not be exist
    End
  End

  Describe 'LINKS'
    It 'names only sources that exist in the repo'
      check_sources() {
        local entry
        for entry in "${LINKS[@]}"; do
          [[ -e "$SCRIPT_DIR/${entry%%:*}" ]] || { echo "missing ${entry%%:*}"; return 1; }
        done
        echo "all ${#LINKS[@]} sources exist"
      }
      When call check_sources
      The status should be success
      The output should equal "all 31 sources exist"
    End
  End

  Describe 'link_files'
    It 'links every LINKS entry into HOME'
      HOME="$TMP/home"
      When call link_files
      The status should be success
      The output should include 'Linked'
      The value "$(readlink "$TMP/home/.zshenv")" should equal "$SCRIPT_DIR/home/.zshenv"
      The value "$(readlink "$TMP/home/bin/nvim-profile")" should equal "$SCRIPT_DIR/config/iterm-profile-wrappers/nvim-profile"
      The value "$(readlink "$TMP/home/.config/nvim")" should equal "$SCRIPT_DIR/config/nvim"
    End
  End

  Describe '--print-links'
    It 'prints tab-separated src and dst for every entry without running any step'
      When run script ./dotfiles.sh --print-links
      The status should be success
      The line 1 of output should equal "$(printf 'home/.zshenv\t.zshenv')"
      The lines of output should equal 31
      The output should not include 'Checking prerequisites'
    End
  End
End

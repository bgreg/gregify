if [[ -o interactive ]]; then
  local tips=(
    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Quick Edits
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'ae' opens aliases.zsh in nvim for quick alias editing"
    "💡 'fe' opens functions.zsh in nvim for function editing"
    "💡 'ze' opens .zshrc in nvim, 'zr' reloads it"
    "💡 've' opens nvim config (init.lua) for editor customization"
    "💡 'shortcuts' displays your QUICK_REFERENCE.md cheatsheet"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Navigation
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'z <partial>' jumps to frequent dirs, 'z -l' lists all with scores"
    "💡 '..' goes up 1 dir, '...' up 2, '....' up 3, '.....' up 4"
    "💡 '1' through '9' jump to directory stack positions (cd -1, cd -2, etc.)"
    "💡 'take dirname' creates a directory and cds into it in one command"
    "💡 'api_service' jumps to ~/workspace/api_service"
    "💡 'dotf' cds to ~/.config/zsh, 'dotv' opens it in nvim"
    "💡 'grt' cds to the git repository root from any subdirectory"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - File Operations
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'copypath' copies current dir path, 'copypath file' copies file's absolute path"
    "💡 'copyfile file.rb' copies entire file contents to clipboard"
    "💡 'x' or 'extract' unpacks any archive (.tar, .gz, .zip, .rar, .7z, .bz2)"
    "💡 'ls' is colorized (-FG), 'll' shows detailed reverse-time sorted listing"
    "💡 'md dirname' creates directory with parents (mkdir -p)"
    "💡 'path' prints each PATH entry on its own line for easy reading"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Git Basics
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'gs' or 'gst' for git status, 'gss' for short status"
    "💡 'ga' adds files, 'gaa' adds all, 'gapa' adds interactively (--patch)"
    "💡 'gc' commits with message, 'gc!' amends, 'gca' commits all"
    "💡 'gd' shows diff, 'gdc' shows staged diff, 'gdw' shows word diff"
    "💡 'gco' checkouts, 'gcb' creates branch, 'gcd' checkouts develop, 'gcm' checkouts main"
    "💡 'gp' pushes, 'gpsh' pushes current branch to origin HEAD"
    "💡 'gl' shows log with stats, 'glog' shows graph, 'gloga' shows all branches"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Git Advanced
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'gbr' lists 10 most recent branches sorted by commit date"
    "💡 'gbin branch' shows commits in branch that aren't in current"
    "💡 'gbout branch' shows commits in current that aren't in branch"
    "💡 'gwip' creates a work-in-progress commit, 'gunwip' undoes it"
    "💡 'grf' lists files changed in the last non-merge commit"
    "💡 'erf' opens all changed files (git diff) in nvim"
    "💡 'pp' stashes, pulls, then pops stash - safe pull with local changes"
    "💡 'gpf' force pushes safely (--force-with-lease --force-if-includes)"
    "💡 'gpsup' pushes and sets upstream for current branch"
    "💡 'fuckit' adds all, amends commit, force pushes (use carefully!)"
    "💡 'clean' runs git clean -fxd to remove all untracked files"
    "💡 'myco' shows only your commits (git log --author=me)"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Git Rebasing & Merging
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'grb' rebases, 'grba' aborts, 'grbc' continues, 'grbs' skips"
    "💡 'grbm' rebases onto main, 'grbd' rebases onto develop"
    "💡 'grbom' rebases onto origin/main (fetched remote)"
    "💡 'gpr' pulls with rebase, 'gpra' also autostashes local changes"
    "💡 'gm' merges, 'gmff' merge fast-forward only, 'gms' merge squash"
    "💡 'gcp' cherry-picks, 'gcpa' aborts, 'gcpc' continues"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Git Stash & Reset
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'gsta' stashes, 'gstp' pops, 'gstl' lists, 'gstd' drops"
    "💡 'gstaa' applies without removing from stash list"
    "💡 'gsts' shows stash diff (--patch)"
    "💡 'grh' resets, 'grhh' hard reset, 'grhs' soft reset"
    "💡 'groh' hard resets to origin/current-branch"
    "💡 'gpristine' resets hard AND cleans all untracked files"
    "💡 'grs' restores files, 'grst' unstages (restore --staged)"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Git Remote & Fetch
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'gf' fetches, 'gfa' fetches all remotes with tags and prune"
    "💡 'gr' manages remotes, 'grv' shows verbose, 'gra' adds remote"
    "💡 'grrm' removes remote, 'grmv' renames remote"
    "💡 'glum' pulls upstream main, 'gluc' pulls upstream current branch"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Git Worktrees
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'gwt' manages worktrees, 'gwta' adds, 'gwtls' lists"
    "💡 'gwtmv' moves worktree, 'gwtrm' removes worktree"
    "💡 Worktrees let you have multiple branches checked out simultaneously"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Rails
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'r' is rails, 'be' is bundle exec"
    "💡 'rc' opens rails console, 'rcs' opens sandboxed console"
    "💡 'rs' starts server, 'rsp 3001' starts on custom port"
    "💡 'rgen' generates, 'rgm' generates migration"
    "💡 'rdm' migrates, 'rdr' rollback, 'rdrs' resets database"
    "💡 'rdms' shows migration status"
    "💡 'rr' shows routes, 'rrg pattern' greps routes"
    "💡 'rebuild' drops, creates, migrates, and seeds database"
    "💡 'migrate' runs db:migrate in development"
    "💡 'spec_scan' runs rspec, rubocop, and brakeman security scan"
    "💡 'check_coverage' runs rspec with coverage and opens report"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Ruby/Bundler
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'bi' installs bundle, 'bu' updates, 'bo' opens gem in editor"
    "💡 'bck' checks bundle, 'bcn' cleans unused gems"
    "💡 'ba' adds gem, 'bl' lists gems, 'bout' shows outdated"
    "💡 'rubies' lists rbenv versions, 'gemsets' lists gemsets"
    "💡 'agr' runs ag (silver searcher) on ruby files only"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Docker
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'doc' is docker, 'dc' is docker compose"
    "💡 'dps' shows running containers, 'dpsa' shows all containers"
    "💡 'dce' executes in rails container, 'dcbe' runs bundle exec in it"
    "💡 'dcr' runs command in new rails container with bundle exec"
    "💡 'dcconsole' opens rails console in docker"
    "💡 'dcmigrate' runs migrations in docker"
    "💡 'dcreset' resets database in docker"
    "💡 'dsta' stops all running containers"
    "💡 'dipru' prunes all unused images"
    "💡 'dvprune' prunes unused volumes"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Homebrew
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'bs' searches brew, 'bi' installs, 'bdr' runs brew doctor"
    "💡 'bcin' installs cask, 'bcl' lists casks, 'bco' shows outdated casks"
    "💡 'bup' upgrades formulas, 'bcup' upgrades casks"
    "💡 'bubo' updates and shows outdated, 'bubu' updates and upgrades all"
    "💡 'bsl' lists services, 'bson' starts, 'bsoff' stops service"
    "💡 'brewp' pins formula, 'brewsp' lists pinned formulas"
    "💡 'buz' uninstalls with zap (removes all associated files)"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - PostgreSQL
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'startpost' starts postgres, 'stoppost' stops it"
    "💡 'statuspost' shows postgres status"
    "💡 'restartpost' restarts postgres"
    "💡 'reloadpost' reloads postgres config without restart"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Logs
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'tf' is tail -f, 'tfd' tails development.log, 'tft' tails test.log"
    "💡 'devlog' is an alias for tfd (development log)"
    "💡 'prodlog' tails production.log, 'testlog' tails test.log"
    "💡 'rlc' clears all rails log files"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Web Search
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'google \"query\"' searches Google from terminal"
    "💡 'stackoverflow \"error\"' searches StackOverflow"
    "💡 'github \"repo\"' searches GitHub"
    "💡 'youtube \"video\"' searches YouTube"
    "💡 'ddg \"query\"' searches DuckDuckGo"
    "💡 'ducky \"query\"' I'm Feeling Lucky on DuckDuckGo"
    "💡 'wiki \"topic\"' searches Wikipedia"
    "💡 'reddit \"topic\"' searches Reddit"
    "💡 'image \"query\"' searches DuckDuckGo images"
    "💡 'map \"location\"' searches DuckDuckGo maps"
    "💡 'news \"topic\"' searches DuckDuckGo news"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - JSON
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'pp_json' pretty-prints JSON, pipe any JSON through it"
    "💡 'is_json' validates if input is valid JSON"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Calendar & Reminders
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'cal-today' shows today's calendar events"
    "💡 'cal-on \"Dec 25\"' shows events for a specific date"
    "💡 'cal-upcoming' shows upcoming events"
    "💡 'cal-list' lists all calendar names"
    "💡 'cal-count' counts events in date range"
    "💡 'rem-add' adds reminder from terminal"
    "💡 'rem-show' shows reminders, 'rem-show \"List\"' shows specific list"
    "💡 'rem-lists' shows all reminder lists"
    "💡 'rem-done' marks reminder complete, 'rem-delete' removes"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - Custom Scripts
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'goodmorning' runs your morning setup script"
    "💡 'clear_desktop' clears desktop clutter"
    "💡 'chrome \"session\"' opens Chrome with specific session"
    "💡 'practice' starts the 7-day terminal skills challenge"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR ALIASES - System
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'fixaudio' kills coreaudiod to fix audio issues (sudo)"
    "💡 'psmem' shows processes sorted by memory, 'psmem10' shows top 10"
    "💡 'showfiles' shows hidden files in Finder, 'hidefiles' hides them"

    # ═══════════════════════════════════════════════════════════════════════════
    # YOUR FUNCTIONS
    # ═══════════════════════════════════════════════════════════════════════════
    "💡 'take dirname' creates and enters directory in one step"
    "💡 'box \"text\"' draws a box around text for visual emphasis"
    "💡 'st \"title\"' sets terminal tab title"
    "💡 'tab_color green/red/orange' sets iTerm2 tab color"
    "💡 'show_colors' displays available color variables"
    "💡 'git_branch_name' returns current git branch name"
    "💡 'gjc' commits with JIRA key from branch name prepended"

    # ═══════════════════════════════════════════════════════════════════════════
    # ZSH - Keyboard Navigation
    # ═══════════════════════════════════════════════════════════════════════════
    "⚡ Ctrl+A jumps to line start, Ctrl+E to end"
    "⚡ Ctrl+U deletes from cursor to line start"
    "⚡ Ctrl+K deletes from cursor to line end"
    "⚡ Ctrl+W deletes word before cursor"
    "⚡ Alt+D deletes word after cursor"
    "⚡ Alt+B moves back one word, Alt+F moves forward one word"
    "⚡ Ctrl+Y pastes (yanks) last deleted text"
    "⚡ Ctrl+_ undoes last edit (can undo multiple times)"
    "⚡ Ctrl+X Ctrl+E opens current command in \$EDITOR"

    # ═══════════════════════════════════════════════════════════════════════════
    # ZSH - History
    # ═══════════════════════════════════════════════════════════════════════════
    "⚡ Ctrl+R fuzzy searches history (fzf), press again for next match"
    "⚡ Up/Down arrows filter history by what you've typed"
    "⚡ !! repeats last command, !$ is last argument, !^ is first argument"
    "⚡ !:n gets nth argument from last command (0=command, 1=first arg)"
    "⚡ !* gets all arguments from last command"
    "⚡ !-2 runs second-to-last command"
    "⚡ ^old^new replaces 'old' with 'new' in last command and runs it"
    "⚡ !cmd runs most recent command starting with 'cmd'"
    "⚡ !cmd:p prints command without running (then up arrow to edit)"
    "⚡ fc opens last command in editor, saves and runs on exit"
    "⚡ fc -l lists history with numbers, fc -l -20 shows last 20"

    # ═══════════════════════════════════════════════════════════════════════════
    # ZSH - Globbing (Pattern Matching)
    # ═══════════════════════════════════════════════════════════════════════════
    "⚡ **/*.rb recursively matches all .rb files in subdirectories"
    "⚡ *(.) matches only regular files, *(/) matches only directories"
    "⚡ *(@) matches only symlinks, *(x) matches only executables"
    "⚡ *(m-7) matches files modified in last 7 days"
    "⚡ *(Lk+100) matches files larger than 100KB"
    "⚡ *(om[1,10]) lists 10 most recently modified files"
    "⚡ *(Om) sorts by modification time (oldest first)"
    "⚡ *(-@) matches broken symlinks"
    "⚡ *(U) matches files owned by you"
    "⚡ ls **/*(D) includes hidden files in recursive glob"
    "⚡ rm -i *(.L0) removes empty files with confirmation"
    "⚡ ^*.txt matches everything except .txt files (EXTENDED_GLOB)"

    # ═══════════════════════════════════════════════════════════════════════════
    # ZSH - Parameter Expansion
    # ═══════════════════════════════════════════════════════════════════════════
    "⚡ \${var:-default} uses default if var is unset or empty"
    "⚡ \${var:=default} sets var to default if unset or empty"
    "⚡ \${var:?error} exits with error if var is unset or empty"
    "⚡ \${#var} returns length of string in var"
    "⚡ \${var%pattern} removes shortest match from end"
    "⚡ \${var%%pattern} removes longest match from end"
    "⚡ \${var#pattern} removes shortest match from start"
    "⚡ \${var##pattern} removes longest match from start"
    "⚡ \${var/old/new} replaces first 'old' with 'new'"
    "⚡ \${var//old/new} replaces all 'old' with 'new'"
    "⚡ \${var:u} converts to uppercase, \${var:l} to lowercase"
    "⚡ \${(s/:/)PATH} splits PATH on colons into array"
    "⚡ \${(j:,:)array} joins array with commas"

    # ═══════════════════════════════════════════════════════════════════════════
    # ZSH - Process Control
    # ═══════════════════════════════════════════════════════════════════════════
    "⚡ Ctrl+Z suspends job, 'fg' resumes foreground, 'bg' resumes background"
    "⚡ 'jobs' lists background jobs with numbers"
    "⚡ 'fg %2' brings job 2 to foreground, '%2' alone also works"
    "⚡ 'kill %1' kills job 1, 'kill %%' kills current job"
    "⚡ 'disown' removes job from shell's job table (survives logout)"
    "⚡ 'nohup cmd &' runs command immune to hangups"
    "⚡ 'cmd &!' or 'cmd &|' runs in background disowned immediately"
    "⚡ 'wait' waits for all background jobs to complete"
    "⚡ ESC ESC prepends sudo to current line (sudo plugin)"

    # ═══════════════════════════════════════════════════════════════════════════
    # ZSH - Completion
    # ═══════════════════════════════════════════════════════════════════════════
    "⚡ Tab completes, Tab Tab shows menu, Tab Tab Tab cycles"
    "⚡ Ctrl+X h shows completion context for debugging"
    "⚡ In completion menu: Ctrl+N/P navigates, Enter selects"
    "⚡ Type in completion menu to filter matches"
    "⚡ Completion works for git branches, docker containers, brew packages"

    # ═══════════════════════════════════════════════════════════════════════════
    # ZSH - Miscellaneous
    # ═══════════════════════════════════════════════════════════════════════════
    "⚡ 'which cmd' shows alias/function definition or binary path"
    "⚡ 'type cmd' shows what cmd resolves to (alias, function, builtin)"
    "⚡ 'whence -v cmd' verbose output showing all matches"
    "⚡ 'autoload -Uz function_name' lazy-loads functions"
    "⚡ 'zargs' is like xargs but native zsh with glob support"
    "⚡ 'zmv \"*.txt\" \"\\$1.bak\"' batch renames with patterns"
    "⚡ 'vared VAR' interactively edits environment variable"
    "⚡ 'print -l array' prints array elements one per line"
    "⚡ 'repeat 5 { cmd }' runs cmd 5 times"
    "⚡ 'REPORTTIME=5' auto-shows timing for commands >5 seconds"
    "⚡ Press Alt+? to show help for command at cursor"

    # ═══════════════════════════════════════════════════════════════════════════
    # GIT - Lesser Known Commands
    # ═══════════════════════════════════════════════════════════════════════════
    "🔧 git bisect start/good/bad - binary search to find bug-introducing commit"
    "🔧 git reflog - history of HEAD changes, recover 'lost' commits"
    "🔧 git stash push -m \"name\" - named stash for clarity"
    "🔧 git stash push -p - interactively select hunks to stash"
    "🔧 git commit --fixup=SHA - creates fixup commit for later squashing"
    "🔧 git rebase -i --autosquash - auto-arranges fixup commits"
    "🔧 git add -N file - stages intent to add, shows in diff but not committed"
    "🔧 git diff --word-diff - shows inline word changes, not line changes"
    "🔧 git diff --stat - shows summary of changed files with +/- counts"
    "🔧 git log -S \"code\" - find commits that added or removed \"code\""
    "🔧 git log -G \"regex\" - find commits with changes matching regex"
    "🔧 git log -p -- file - shows full diff history of single file"
    "🔧 git log --follow -- file - tracks file through renames"
    "🔧 git blame -L 10,20 file - blame specific line range"
    "🔧 git blame -w - ignores whitespace when assigning blame"
    "🔧 git show SHA:path/file - shows file contents at specific commit"
    "🔧 git checkout SHA -- file - restore file from specific commit"
    "🔧 git restore -s SHA -- file - modern way to restore from commit"

    # ═══════════════════════════════════════════════════════════════════════════
    # GIT - Rewriting History
    # ═══════════════════════════════════════════════════════════════════════════
    "🔧 git rebase -i HEAD~5 - interactively edit last 5 commits"
    "🔧 In rebase: 'r' rewrites message, 's' squashes, 'f' fixup (no msg)"
    "🔧 In rebase: 'd' drops commit, 'e' edit (pause to amend)"
    "🔧 git commit --amend --no-edit - adds staged changes to last commit"
    "🔧 git commit --amend --reset-author - updates commit author"
    "🔧 git rebase --onto new old branch - moves branch to new base"
    "🔧 git filter-branch / git filter-repo - rewrite entire history"
    "🔧 git reset --soft HEAD~1 - undo commit but keep changes staged"
    "🔧 git reset --mixed HEAD~1 - undo commit, unstage changes (default)"

    # ═══════════════════════════════════════════════════════════════════════════
    # GIT - Collaboration
    # ═══════════════════════════════════════════════════════════════════════════
    "🔧 git range-diff main..@{u} main..@ - compare two versions of a branch"
    "🔧 git cherry -v main - shows commits not yet merged to main"
    "🔧 git merge-base main feature - finds common ancestor commit"
    "🔧 git log main..feature - shows commits in feature not in main"
    "🔧 git log main...feature - shows commits unique to either branch"
    "🔧 git shortlog -sn - shows commit counts by author"
    "🔧 git rev-list --count HEAD - total number of commits in history"
    "🔧 git for-each-ref --sort=-committerdate - list refs by date"
    "🔧 git notes add -m \"note\" SHA - add notes to commits without changing SHA"

    # ═══════════════════════════════════════════════════════════════════════════
    # GIT - Maintenance & Recovery
    # ═══════════════════════════════════════════════════════════════════════════
    "🔧 git gc --aggressive - optimize repository, reclaim space"
    "🔧 git fsck - verify integrity and find dangling objects"
    "🔧 git fsck --lost-found - recovers dangling commits to .git/lost-found"
    "🔧 git clean -fdx - removes ALL untracked files including ignored"
    "🔧 git clean -fdn - dry run, shows what would be deleted"
    "🔧 git update-index --assume-unchanged file - ignore local changes"
    "🔧 git update-index --skip-worktree file - prefer for config files"
    "🔧 git ls-files -v | grep ^h - shows files with assume-unchanged"
    "🔧 git rerere - remembers conflict resolutions for reuse"
    "🔧 ORIG_HEAD points to previous HEAD before dangerous operations"

    # ═══════════════════════════════════════════════════════════════════════════
    # GIT - Advanced Diff & Merge
    # ═══════════════════════════════════════════════════════════════════════════
    "🔧 git diff --patience - uses patience algorithm, better for refactoring"
    "🔧 git diff --histogram - often produces better diffs than default"
    "🔧 git diff --color-moved - highlights moved blocks in different color"
    "🔧 git diff --diff-filter=M - only show modified files (A/D/M/R/C)"
    "🔧 git merge -X theirs/ours - auto-resolve conflicts favoring one side"
    "🔧 git checkout --conflict=diff3 file - shows base in conflict markers"
    "🔧 git diff HEAD@{yesterday} - diff against yesterday's HEAD"
    "🔧 git diff :1:file :2:file :3:file - during merge: base, ours, theirs"

    # ═══════════════════════════════════════════════════════════════════════════
    # GIT - Worktrees
    # ═══════════════════════════════════════════════════════════════════════════
    "🔧 git worktree add ../hotfix hotfix-branch - parallel branch checkout"
    "🔧 Worktrees let you work on multiple branches without stashing"
    "🔧 Great for: code review, hotfixes while mid-feature, comparisons"
    "🔧 git worktree list - shows all worktrees"
    "🔧 git worktree remove ../hotfix - cleans up worktree"

    # ═══════════════════════════════════════════════════════════════════════════
    # MACOS - defaults Command (System Preferences)
    # ═══════════════════════════════════════════════════════════════════════════
    "🍎 defaults read - reads all domains, add domain for specific settings"
    "🍎 defaults read com.apple.dock - shows all Dock preferences"
    "🍎 defaults write com.apple.dock autohide -bool true - auto-hide Dock"
    "🍎 defaults write com.apple.dock autohide-delay -float 0 - instant unhide"
    "🍎 defaults write com.apple.dock autohide-time-modifier -float 0.5 - animation speed"
    "🍎 defaults write com.apple.dock mineffect -string scale - minimize animation"
    "🍎 defaults write com.apple.dock show-recents -bool false - hide recent apps"
    "🍎 defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false - key repeat"
    "🍎 defaults write NSGlobalDomain KeyRepeat -int 1 - fastest key repeat"
    "🍎 defaults write NSGlobalDomain InitialKeyRepeat -int 10 - faster repeat start"
    "🍎 After defaults changes, restart affected app or 'killall Dock/Finder'"

    # ═══════════════════════════════════════════════════════════════════════════
    # MACOS - Finder
    # ═══════════════════════════════════════════════════════════════════════════
    "🍎 defaults write com.apple.finder AppleShowAllFiles -bool true - show hidden"
    "🍎 defaults write com.apple.finder ShowPathbar -bool true - show path bar"
    "🍎 defaults write com.apple.finder ShowStatusBar -bool true - show status bar"
    "🍎 defaults write com.apple.finder _FXShowPosixPathInTitle -bool true - full path in title"
    "🍎 defaults write com.apple.finder FXDefaultSearchScope -string SCcf - search current folder"
    "🍎 defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false"
    "🍎 defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true - no .DS_Store on network"
    "🍎 chflags hidden ~/Desktop/file - hide file from Finder (not ls)"
    "🍎 SetFile -a V file - hide file in Finder (legacy)"

    # ═══════════════════════════════════════════════════════════════════════════
    # MACOS - Screenshots
    # ═══════════════════════════════════════════════════════════════════════════
    "🍎 defaults write com.apple.screencapture location ~/Screenshots - change save location"
    "🍎 defaults write com.apple.screencapture type png - format: png/jpg/pdf/gif"
    "🍎 defaults write com.apple.screencapture disable-shadow -bool true - no window shadow"
    "🍎 defaults write com.apple.screencapture name \"screenshot\" - custom filename prefix"
    "🍎 screencapture -i - interactive selection"
    "🍎 screencapture -iW - interactive window selection"
    "🍎 screencapture -c - capture to clipboard"
    "🍎 screencapture -T 5 - capture after 5 second delay"

    # ═══════════════════════════════════════════════════════════════════════════
    # MACOS - System Commands
    # ═══════════════════════════════════════════════════════════════════════════
    "🍎 pmset -g - shows power management settings and battery info"
    "🍎 pmset -g batt - battery percentage and power source"
    "🍎 caffeinate -d - prevent display sleep"
    "🍎 caffeinate -i - prevent idle sleep"
    "🍎 caffeinate -u -t 3600 - prevent sleep for 1 hour"
    "🍎 sudo pmset -a standby 0 - disable standby mode"
    "🍎 sudo nvram StartupMute=%00 - enable startup sound"
    "🍎 diskutil list - shows all disks and partitions"
    "🍎 diskutil info disk0s1 - detailed info about partition"
    "🍎 diskutil apfs list - shows APFS container details"
    "🍎 softwareupdate -l - list available updates"
    "🍎 softwareupdate -ia - install all available updates"

    # ═══════════════════════════════════════════════════════════════════════════
    # MACOS - Process & Diagnostics
    # ═══════════════════════════════════════════════════════════════════════════
    "🍎 sudo fs_usage - real-time file system activity (amazing for debugging)"
    "🍎 sudo opensnoop - monitors file opens in real-time"
    "🍎 sudo dtruss -p PID - trace syscalls like strace"
    "🍎 sample PID 5 - samples process for 5 seconds (CPU profiling)"
    "🍎 log show --predicate 'process == \"app\"' --last 1h - read system logs"
    "🍎 log stream --predicate 'process == \"app\"' - live log streaming"
    "🍎 sudo spindump PID - creates hang report for unresponsive process"
    "🍎 heap PID - shows memory allocation by library"
    "🍎 leaks PID - detects memory leaks"
    "🍎 vmmap PID - virtual memory map"
    "🍎 sudo powermetrics - detailed power and performance stats"
    "🍎 ioreg -l - full I/O registry dump"
    "🍎 system_profiler SPHardwareDataType - hardware info"

    # ═══════════════════════════════════════════════════════════════════════════
    # MACOS - Networking
    # ═══════════════════════════════════════════════════════════════════════════
    "🍎 networksetup -listallhardwareports - shows all network interfaces"
    "🍎 networksetup -getinfo \"Wi-Fi\" - shows IP config for interface"
    "🍎 networksetup -setairportpower en0 off/on - toggle Wi-Fi"
    "🍎 sudo dscacheutil -flushcache - flush DNS cache"
    "🍎 sudo killall -HUP mDNSResponder - also flushes DNS"
    "🍎 scutil --dns - shows DNS configuration"
    "🍎 netstat -an | grep LISTEN - shows listening ports"
    "🍎 lsof -iTCP -sTCP:LISTEN - processes listening on TCP"
    "🍎 lsof -i :3000 - what's using port 3000"
    "🍎 nc -zv host 1-1024 - port scan host"
    "🍎 sudo tcpdump -i en0 - capture packets on interface"
    "🍎 networkQuality - measures network speed (built-in)"

    # ═══════════════════════════════════════════════════════════════════════════
    # MACOS - Security & Permissions
    # ═══════════════════════════════════════════════════════════════════════════
    "🍎 xattr -l file - list extended attributes (quarantine, etc)"
    "🍎 xattr -d com.apple.quarantine file - remove quarantine flag"
    "🍎 xattr -cr /path/to/app - clear all xattrs recursively"
    "🍎 codesign -v /path/to/app - verify code signature"
    "🍎 codesign -dv --verbose=4 app - detailed signature info"
    "🍎 spctl --assess --verbose app - Gatekeeper assessment"
    "🍎 security find-identity -v -p codesigning - list signing identities"
    "🍎 sudo spctl --master-disable - disable Gatekeeper (danger!)"
    "🍎 csrutil status - check System Integrity Protection status"
    "🍎 tccutil reset All - reset all privacy permissions"

    # ═══════════════════════════════════════════════════════════════════════════
    # MACOS - Launchd (Service Management)
    # ═══════════════════════════════════════════════════════════════════════════
    "🍎 launchctl list - shows loaded launch agents/daemons"
    "🍎 launchctl load ~/Library/LaunchAgents/my.plist - load agent"
    "🍎 launchctl unload plist - stop and unload agent"
    "🍎 launchctl kickstart -k gui/\$(id -u)/service - restart user service"
    "🍎 launchctl blame gui/\$(id -u)/service - why service stopped"
    "🍎 launchctl print gui/\$(id -u) - print user domain info"
    "🍎 User agents: ~/Library/LaunchAgents, System: /Library/LaunchDaemons"
    "🍎 launchctl bootstrap gui/\$(id -u) plist - modern way to load"
    "🍎 launchctl bootout gui/\$(id -u)/label - modern way to unload"

    # ═══════════════════════════════════════════════════════════════════════════
    # MACOS - AppleScript & Automation
    # ═══════════════════════════════════════════════════════════════════════════
    "🍎 osascript -e 'display notification \"msg\" with title \"title\"'"
    "🍎 osascript -e 'say \"hello\"' - text to speech"
    "🍎 osascript -e 'tell app \"Finder\" to open home' - control apps"
    "🍎 osascript -e 'tell app \"System Events\" to keystroke \"c\" using command down'"
    "🍎 osascript -e 'set volume output volume 50' - set volume 0-100"
    "🍎 automator - GUI automation tool, can export as apps/services"
    "🍎 shortcuts run \"shortcut name\" - run Shortcuts from CLI"
    "🍎 pbcopy/pbpaste - clipboard access: echo foo | pbcopy"

    # ═══════════════════════════════════════════════════════════════════════════
    # MACOS - Quick Look & Spotlight
    # ═══════════════════════════════════════════════════════════════════════════
    "🍎 qlmanage -p file - Quick Look preview from terminal"
    "🍎 qlmanage -t file -s 1000 -o . - generate thumbnail"
    "🍎 mdls file - shows Spotlight metadata for file"
    "🍎 mdfind \"query\" - command-line Spotlight search"
    "🍎 mdfind -name \"filename\" - search by filename"
    "🍎 mdfind kind:pdf - search by file type"
    "🍎 mdfind -onlyin ~/Documents query - search specific folder"
    "🍎 mdutil -s / - Spotlight indexing status"
    "🍎 sudo mdutil -E / - rebuild Spotlight index"
    "🍎 mdimport file - manually import file to Spotlight"

    # ═══════════════════════════════════════════════════════════════════════════
    # MACOS - File System
    # ═══════════════════════════════════════════════════════════════════════════
    "🍎 sudo tmutil listlocalsnapshots / - list Time Machine snapshots"
    "🍎 tmutil localsnapshot - create local snapshot"
    "🍎 tmutil deletelocalsnapshots date - delete snapshot"
    "🍎 ditto source dest - better than cp, preserves resource forks"
    "🍎 ditto -V source dest.zip - create archive preserving metadata"
    "🍎 hdiutil create -size 1g -type SPARSE -fs HFS+ disk.sparseimage"
    "🍎 hdiutil attach disk.dmg - mount disk image"
    "🍎 hdiutil detach /Volumes/Name - unmount disk image"
    "🍎 GetFileInfo file - shows file flags (invisible, etc)"
    "🍎 SetFile -a l file - lock file from modification"

    # ═══════════════════════════════════════════════════════════════════════════
    # MACOS - Open Command
    # ═══════════════════════════════════════════════════════════════════════════
    "🍎 open . - opens current directory in Finder"
    "🍎 open -a \"App Name\" file - opens file with specific app"
    "🍎 open -e file - opens file in TextEdit"
    "🍎 open -R file - reveals file in Finder"
    "🍎 open -n -a \"App\" - opens new instance of app"
    "🍎 open -g file - opens in background (no focus)"
    "🍎 open -b com.apple.Safari url - open with bundle identifier"
    "🍎 open \"x-apple.systempreferences:\" - open System Settings"

    # ═══════════════════════════════════════════════════════════════════════════
    # MACOS - Misc Power User
    # ═══════════════════════════════════════════════════════════════════════════
    "🍎 plutil -lint file.plist - validate plist file"
    "🍎 plutil -convert xml1 file.plist - convert binary plist to XML"
    "🍎 /usr/libexec/PlistBuddy -c \"Print\" file.plist - edit plists"
    "🍎 sysctl -a | grep cpu - shows CPU info"
    "🍎 sysctl hw.memsize - total RAM in bytes"
    "🍎 sw_vers - shows macOS version info"
    "🍎 pkgutil --pkgs - list all installed packages"
    "🍎 pkgutil --files package.id - list files in package"
    "🍎 sudo pkgutil --forget package.id - remove package receipt"
    "🍎 textutil -convert txt doc.docx - convert document formats"
    "🍎 say -v \"?\" - list all available voices"
    "🍎 say -v Samantha -o output.aiff \"text\" - save speech to file"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - find Command (works on macOS & Linux)
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 find . -name '*.rb' -mtime -7 - files modified in last 7 days"
    "🐧 find . -type f -empty - find all empty files"
    "🐧 find . -type d -empty - find all empty directories"
    "🐧 find . -size +100M - files larger than 100MB"
    "🐧 find . -perm 777 - files with specific permissions"
    "🐧 find . -user root - files owned by root"
    "🐧 find . -newer reference.txt - files newer than reference"
    "🐧 find . -name '*.log' -delete - delete matching files (careful!)"
    "🐧 find . -name '*.rb' -exec grep -l 'pattern' {} \\; - find and grep"
    "🐧 find . -name '*.rb' -exec wc -l {} + - count lines in all .rb files"
    "🐧 find . -maxdepth 2 -name '*.txt' - limit search depth"
    "🐧 find . ! -name '*.rb' - files NOT matching pattern"
    "🐧 find . -name '*.rb' -o -name '*.py' - OR multiple patterns"
    "🐧 find . -type f -name '*.rb' -print0 | xargs -0 cmd - handle spaces in names"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - xargs (parallel execution)
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 echo 'a b c' | xargs -n1 - process one arg at a time"
    "🐧 find . -name '*.rb' | xargs grep 'pattern' - grep in found files"
    "🐧 xargs -P4 - run up to 4 processes in parallel"
    "🐧 xargs -I {} cmd {} - use {} as placeholder for input"
    "🐧 xargs -t - print commands before executing"
    "🐧 xargs -p - prompt before each execution"
    "🐧 cat list.txt | xargs -L1 cmd - one line as one argument"
    "🐧 find . -print0 | xargs -0 - null-separated for filenames with spaces"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - sed (stream editor)
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 sed 's/old/new/' file - replace first occurrence per line"
    "🐧 sed 's/old/new/g' file - replace all occurrences"
    "🐧 sed -i '' 's/old/new/g' file - edit in place (macOS)"
    "🐧 sed -n '5,10p' file - print only lines 5-10"
    "🐧 sed '5d' file - delete line 5"
    "🐧 sed '/pattern/d' file - delete lines matching pattern"
    "🐧 sed '/^$/d' file - delete empty lines"
    "🐧 sed 's/^/prefix/' file - add prefix to each line"
    "🐧 sed 's/$/ suffix/' file - add suffix to each line"
    "🐧 sed '1i\\header' file - insert 'header' before first line"
    "🐧 sed '/pattern/a\\newline' file - append after matching lines"
    "🐧 sed -n '/start/,/end/p' file - print between patterns"
    "🐧 sed 's/[0-9]\\+/NUMBER/g' - replace all numbers"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - awk (pattern scanning)
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 awk '{print \\$1}' file - print first column"
    "🐧 awk '{print \\$NF}' file - print last column"
    "🐧 awk -F: '{print \\$1}' - use : as field separator"
    "🐧 awk 'NR==5' file - print line 5"
    "🐧 awk 'NR>=5 && NR<=10' file - print lines 5-10"
    "🐧 awk '/pattern/' file - print lines matching pattern"
    "🐧 awk '!/pattern/' file - print lines NOT matching"
    "🐧 awk '{sum+=\\$1} END {print sum}' - sum first column"
    "🐧 awk '{print length}' - print length of each line"
    "🐧 awk 'length > 80' - print lines longer than 80 chars"
    "🐧 awk '{gsub(/old/,\"new\"); print}' - substitute globally"
    "🐧 awk -v var=\\$x '{print var, \\$1}' - pass shell variable"
    "🐧 awk 'BEGIN{OFS=\",\"} {print \\$1,\\$2}' - custom output separator"
    "🐧 awk '{arr[\\$1]++} END {for (i in arr) print i, arr[i]}' - frequency count"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - sort & uniq
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 sort -n file - numeric sort"
    "🐧 sort -r file - reverse sort"
    "🐧 sort -k2 file - sort by second column"
    "🐧 sort -t: -k3 -n - sort by 3rd :-delimited field numerically"
    "🐧 sort -u file - sort and remove duplicates"
    "🐧 sort -h file - human-readable numbers (1K, 2M, 3G)"
    "🐧 sort -R file - random shuffle"
    "🐧 uniq - remove adjacent duplicates (pipe through sort first)"
    "🐧 uniq -c - count occurrences"
    "🐧 uniq -d - only show duplicates"
    "🐧 uniq -u - only show unique lines"
    "🐧 sort file | uniq -c | sort -rn - frequency count sorted"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - cut, paste, tr
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 cut -d: -f1 /etc/passwd - extract first field (:-delimited)"
    "🐧 cut -c1-10 file - extract characters 1-10"
    "🐧 cut -d, -f2,4 file.csv - extract columns 2 and 4"
    "🐧 paste file1 file2 - merge files side by side"
    "🐧 paste -d, file1 file2 - merge with comma separator"
    "🐧 paste -s file - merge all lines into one"
    "🐧 tr 'a-z' 'A-Z' - convert to uppercase"
    "🐧 tr -d '\\n' - delete newlines"
    "🐧 tr -s ' ' - squeeze repeated spaces"
    "🐧 tr -dc 'a-zA-Z0-9' - delete non-alphanumeric chars"
    "🐧 tr '\\t' ',' < file - convert tabs to commas"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - head, tail, wc
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 head -n 20 file - first 20 lines"
    "🐧 head -c 100 file - first 100 bytes"
    "🐧 tail -n 20 file - last 20 lines"
    "🐧 tail -f file - follow file as it grows (logs)"
    "🐧 tail -F file - follow even if file is rotated"
    "🐧 tail -n +10 file - from line 10 onwards"
    "🐧 wc -l file - count lines"
    "🐧 wc -w file - count words"
    "🐧 wc -c file - count bytes"
    "🐧 wc -m file - count characters"
    "🐧 wc -L file - length of longest line"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - diff, comm, cmp
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 diff file1 file2 - show differences"
    "🐧 diff -u file1 file2 - unified format (git-style)"
    "🐧 diff -y file1 file2 - side-by-side comparison"
    "🐧 diff -r dir1 dir2 - recursive directory diff"
    "🐧 diff -q dir1 dir2 - only report different files"
    "🐧 comm file1 file2 - compare sorted files (3 columns)"
    "🐧 comm -12 file1 file2 - only lines in both files"
    "🐧 comm -23 file1 file2 - only lines unique to file1"
    "🐧 cmp file1 file2 - byte-by-byte comparison"
    "🐧 cmp -l file1 file2 - list all differing bytes"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - tar, gzip, compression
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 tar -cvf archive.tar dir/ - create archive (verbose)"
    "🐧 tar -xvf archive.tar - extract archive"
    "🐧 tar -tvf archive.tar - list contents without extracting"
    "🐧 tar -czvf archive.tar.gz dir/ - create gzipped archive"
    "🐧 tar -xzvf archive.tar.gz - extract gzipped archive"
    "🐧 tar -cjvf archive.tar.bz2 dir/ - create bzip2 archive"
    "🐧 tar --exclude='*.log' -cvf archive.tar dir/ - exclude pattern"
    "🐧 tar -cvf - dir/ | gzip > archive.tar.gz - pipe through gzip"
    "🐧 gzip -k file - compress keeping original"
    "🐧 gzip -d file.gz - decompress"
    "🐧 zcat file.gz - view compressed file without extracting"
    "🐧 zgrep pattern file.gz - grep in compressed file"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - Process Management
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 ps aux - show all processes with details"
    "🐧 ps aux | grep process - find specific process"
    "🐧 ps -ef --forest - show process tree (Linux)"
    "🐧 pgrep -f 'pattern' - find PIDs by pattern"
    "🐧 pkill -f 'pattern' - kill processes by pattern"
    "🐧 kill -0 PID - check if process exists (no signal sent)"
    "🐧 kill -STOP PID - pause process"
    "🐧 kill -CONT PID - resume paused process"
    "🐧 kill -HUP PID - reload config (by convention)"
    "🐧 killall -9 name - forcefully kill all by name"
    "🐧 nice -n 10 cmd - run with lower priority"
    "🐧 renice -n 5 -p PID - change priority of running process"
    "🐧 timeout 10 cmd - kill command after 10 seconds"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - Disk & Space
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 df -h - disk space in human-readable format"
    "🐧 df -i - show inode usage"
    "🐧 du -sh dir/ - summarize directory size"
    "🐧 du -h --max-depth=1 - size of each subdirectory"
    "🐧 du -sh * | sort -h - directories sorted by size"
    "🐧 du -a dir/ | sort -rn | head -20 - 20 largest files"
    "🐧 ncdu - interactive disk usage viewer (if installed)"
    "🐧 dd if=/dev/zero of=file bs=1M count=100 - create 100MB test file"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - Text Processing Tricks
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 tee file - write stdin to file AND stdout"
    "🐧 tee -a file - append instead of overwrite"
    "🐧 cmd 2>&1 | tee log.txt - capture stdout and stderr"
    "🐧 column -t file - format as aligned columns"
    "🐧 column -t -s, file.csv - format CSV as table"
    "🐧 rev file - reverse each line character by character"
    "🐧 tac file - reverse line order (cat backwards)"
    "🐧 nl file - add line numbers"
    "🐧 expand file - convert tabs to spaces"
    "🐧 unexpand file - convert spaces to tabs"
    "🐧 fold -w 80 file - wrap lines at 80 characters"
    "🐧 fmt -w 80 file - reformat paragraphs to 80 chars"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - Permissions & Ownership
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 chmod 755 file - rwxr-xr-x (common for scripts)"
    "🐧 chmod 644 file - rw-r--r-- (common for files)"
    "🐧 chmod +x file - add execute permission"
    "🐧 chmod -R 755 dir/ - recursive permission change"
    "🐧 chmod u+s file - set SUID bit"
    "🐧 chown user:group file - change owner and group"
    "🐧 chown -R user:group dir/ - recursive ownership change"
    "🐧 chgrp group file - change group only"
    "🐧 stat file - show all file metadata"
    "🐧 umask 022 - default permissions mask"
    "🐧 getfacl file - show access control list"
    "🐧 setfacl -m u:user:rwx file - set ACL"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - Network Tools
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 curl -O url - download file"
    "🐧 curl -I url - show headers only"
    "🐧 curl -s url | jq . - silent mode, pipe to jq for JSON"
    "🐧 curl -X POST -d 'data' url - POST request"
    "🐧 curl -u user:pass url - basic auth"
    "🐧 wget -c url - resume interrupted download"
    "🐧 wget -r -l 2 url - recursive download, 2 levels deep"
    "🐧 wget --mirror url - mirror entire site"
    "🐧 nc -l 8080 - listen on port 8080"
    "🐧 nc host 8080 < file - send file to host:8080"
    "🐧 ssh -L 8080:remote:80 user@host - local port forward"
    "🐧 ssh -R 8080:localhost:80 user@host - remote port forward"
    "🐧 ssh -D 1080 user@host - SOCKS proxy"
    "🐧 scp file user@host:/path - copy file to remote"
    "🐧 rsync -avz src/ user@host:/dest/ - sync with compression"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - Date & Time
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 date +%Y-%m-%d - output: 2024-01-15"
    "🐧 date +%s - Unix timestamp"
    "🐧 date -r 1705334400 - convert timestamp to date (macOS)"
    "🐧 date -d @1705334400 - convert timestamp to date (Linux)"
    "🐧 date -v+1d - tomorrow (macOS)"
    "🐧 date -d 'next monday' - next monday (Linux)"
    "🐧 cal - current month calendar"
    "🐧 cal 2024 - full year calendar"
    "🐧 cal -3 - show 3 months"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - Redirection & Pipes
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 cmd > file - redirect stdout to file (overwrite)"
    "🐧 cmd >> file - redirect stdout to file (append)"
    "🐧 cmd 2> file - redirect stderr to file"
    "🐧 cmd &> file - redirect both stdout and stderr"
    "🐧 cmd 2>&1 - redirect stderr to stdout"
    "🐧 cmd1 | cmd2 - pipe stdout of cmd1 to stdin of cmd2"
    "🐧 cmd1 |& cmd2 - pipe stdout AND stderr"
    "🐧 cmd < file - use file as stdin"
    "🐧 cmd <<< 'string' - here-string as stdin"
    "🐧 cmd1 && cmd2 - run cmd2 only if cmd1 succeeds"
    "🐧 cmd1 || cmd2 - run cmd2 only if cmd1 fails"
    "🐧 (cmd1; cmd2) - run in subshell"
    "🐧 { cmd1; cmd2; } - group commands (same shell)"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - Environment & Variables
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 env - show all environment variables"
    "🐧 printenv VAR - print specific variable"
    "🐧 export VAR=value - set and export variable"
    "🐧 unset VAR - remove variable"
    "🐧 VAR=value cmd - set variable for single command"
    "🐧 set -x - enable debug mode (show commands)"
    "🐧 set -e - exit on first error"
    "🐧 set -u - error on undefined variables"
    "🐧 set -o pipefail - pipeline fails if any command fails"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - Checksums & Hashing
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 md5 file (macOS) / md5sum file (Linux) - MD5 hash"
    "🐧 shasum -a 256 file - SHA-256 hash"
    "🐧 shasum -c checksums.txt - verify checksums"
    "🐧 openssl dgst -sha256 file - alternative SHA-256"
    "🐧 base64 file - encode to base64"
    "🐧 base64 -D file (macOS) / base64 -d file (Linux) - decode"

    # ═══════════════════════════════════════════════════════════════════════════
    # UNIX - Miscellaneous
    # ═══════════════════════════════════════════════════════════════════════════
    "🐧 yes | cmd - automatically answer 'yes' to prompts"
    "🐧 yes n | cmd - automatically answer 'no' to prompts"
    "🐧 watch -n 5 cmd - run cmd every 5 seconds"
    "🐧 time cmd - measure execution time"
    "🐧 script session.log - record terminal session"
    "🐧 seq 1 10 - generate sequence 1 to 10"
    "🐧 seq -s, 1 10 - comma-separated sequence"
    "🐧 shuf file - randomly shuffle lines"
    "🐧 sleep 5 - pause for 5 seconds"
    "🐧 true - always returns success (exit 0)"
    "🐧 false - always returns failure (exit 1)"
    "🐧 : - null command, always succeeds"
    "🐧 command -v cmd - check if command exists"
    "🐧 file filename - determine file type"
    "🐧 strings binary - extract text from binary"
    "🐧 od -c file - octal dump (useful for debugging)"
    "🐧 xxd file - hexdump with ASCII"
    "🐧 less +F file - like tail -f but scrollable"
  )
  echo ${tips[$(($RANDOM % ${#tips[@]} + 1))]}
fi

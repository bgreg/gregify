# Custom aliases for Oh My Zsh
# This file is automatically loaded by Oh My Zsh

# Quick edit aliases
alias ae="nvim ~/.config/oh-my-zsh/custom/aliases.zsh; source ~/.config/oh-my-zsh/custom/aliases.zsh"
alias fe="nvim ~/.config/oh-my-zsh/custom/functions.zsh; source ~/.config/oh-my-zsh/custom/functions.zsh"
alias ze="nvim ~/.config/zsh/.zshrc; source ~/.config/zsh/.zshrc"
alias ve="nvim ~/.config/nvim/lua/keymaps.lua"
alias zr="source ~/.config/zsh/.zshrc"
alias shortcuts="cat ~/.config/zsh/QUICK_REFERENCE.md"

# General utilities
alias c="clear"
alias h="history"
alias ls="ls -FG"
alias ll="ls -laFhGrt"
alias path="echo -e \${PATH//:/\\\\n}"
alias ping="ping -c 5"

# Confirmation prompts
alias rm='rm -i'
alias mv="mv -i"
alias cp="cp -i"
alias ln="ln -i"
alias wget="wget -c"

# Git aliases ( some are overriding oh-my-zsh )
alias gpsh="git push origin HEAD"
alias gciv="git ci -v"
alias gca="git cia"
alias gci="git ci -m"
alias gcip="git cip"
alias gs="git status"
alias gdc="git diff --cached"
alias pp="git stash && git pull && git pop"
alias myco="git log --author=me"
alias clean="git clean -fxd"
alias grf="git diff-tree --no-commit-id --name-only -r \$(git rev-list --no-merges -n 1 HEAD)"
alias erf="nvim \$(git diff --name-only)"
alias gbr="git for-each-ref --sort=-committerdate --format=\"%(refname:short)\" refs/heads/ | head -10"
alias gl="git log --stat"
alias fuckit="gaa && gcn! && gpsup --force-with-lease"
alias gcd='git checkout develop'

# Rails/Ruby aliases
alias migrate="RAILS_ENV=development rails db:migrate"
alias rebuild="rails db:environment:set RAILS_ENV=development && rails db:drop db:create db:migrate db:seed"
alias spec_scan="rspec spec && rubocop && brakeman --run-all-checks --summary --exit-on-warn --quiet && echo -e \"\\n\$COL_RED All Checks Passed! \$COL_RESET\""
alias check_coverage="CHECK_COVERAGE=true rspec spec && open coverage/index.html"
alias agr="ag --ruby"

# Tail log files
alias tf="tail -f"
alias tfd="tf log/development.log"
alias tft="tf log/test.log"

# Docker aliases
alias doc="docker"
alias dps="docker ps"
alias dc="docker compose"
alias dce="docker compose exec api"
alias dcbe="docker compose exec api bundle exec"
alias dcr="docker compose run --rm api bundle exec"
alias dcreset="docker compose run --rm api bundle exec rails db:reset"
alias dcmigrate="docker compose run --rm api bundle exec rails db:migrate"
alias dcconsole="api;docker compose run --rm api bundle exec rails console"


# iTerm2 profile switching wrappers
alias vi="nvim-profile"
alias vim="nvim-profile"
alias nvim="nvim-profile"
alias v="nvim-profile"
alias svi="sudo vi"

# Process monitoring
alias psmem="ps auxf | sort -nr -k 4"
alias psmem10="ps auxf | sort -nr -k 4 | head -10"

alias heroku_deploy="git push heroku master"
alias clear_desktop="\$HOME/.config/zsh/scripts/clear-desktop.sh"
alias goodmorning="\$HOME/Personal/goodmorning-script/goodmorning.sh"
alias rem-lists="reminders show-lists"
alias cal-list="osascript -e 'tell application \"Calendar\" to name of every calendar'"
alias claude="nocorrect claude-profile" # my custom wrapper
alias cc=claude
alias rspec="nocorrect rspec"

# Directory navigation
alias goodmorning_script="cd $HOME/Personal/goodmorning-script"
alias personal="cd ~/Personal"
alias workspace="cd ~/Workspace"
alias tracker="cd ~/Personal/job-application-tracker"


# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gregyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew bundler gem rails rake rvm)


source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:~/projects/topo/commands:/usr/X11/bin:/usr/local:/usr/local/mysql-5.1.73-osx10.6-x86_64/bin"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"



#     My stuff # 

#vim mode
bindkey -v
export KEYTIMEOUT=1
bindkey '^R' history-incremental-search-backward # Don't loose reverse search in vim mode



# # Path
# export PATH=:$HOME/.rvm/bin:~:/usr/local/git/bin::/usr/local/mysql/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:$HOME/.bin:$HOME/.rvm/bin:/opt/local/bin:/opt/local/sbin:$PATH

# Ruby releated
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

# GC Tuning
export RUBY_GC_HEAP_INIT_SLOTS=1250000
export RUBY_HEAP_SLOTS_INCREMENT=100000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=30000000
export RUBY_HEAP_FREE_MIN=12500


# aliases
alias ze='vim ~/.zshrc'
alias zr='source ~/.zshrc'
alias ve='vim ~/.vimrc'
alias vi='vim'


# Setup the Gemset aliases
alias rvmu='rvm use'
# Useful for watching logs
alias tf='tail -f'
alias tfd='tf log/development.log'
alias tft='tf log/test.log'

# Brew doesn't properly override ctags
alias ctags="`brew --prefix`/bin/ctags"

# Navigating
alias l="ls"
alias la="ls -la"
alias lah="ls -lah"

# A script to recursively find and replace through folders using Perl
alias rr="~/.scripts/recursive_replace.sh"


# DB aliases
alias m="mysql -u root"
alias initdb="rake db:init_dev_db && user"
alias ddb="rake db:init_dev_db db:test:clone"
alias mysql_restart="sudo /Library/StartupItems/MySQLCOM/MySQLCOM restart"


# rails
# Rails/Ruby related aliases
alias user="rake db:create_user[\"greg\",\"greg@paynearme.com\"]"
alias rdm="rake db:migrate && rake db:test:clone"
alias t="cd ~/projects/topo"
alias rc="zeus console"

alias gl="git log"
alias rspec='nocorrect rspec'
alias gs='gst'
alias gbr='git for-each-ref --sort=-committerdate refs/heads/ | head' 
alias bastion='ssh gmcguirk@bastion.paynearme.com'
alias agr='ag --ruby'

# functions
gjc () {
    echo
    echo "==============================================================================="
    echo "Your Commit Message: $(g rev-parse --abbrev-ref HEAD) - $1"
    echo "==============================================================================="
    echo
    g commit -m "$(g rev-parse --abbrev-ref HEAD) - $1"
    g commit --amend
}

st () {
  echo -ne "\e]1;$1\a"
}

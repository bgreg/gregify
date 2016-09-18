# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=~/.zsh/themes

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# ZSH related options
# For more interesting options, use man zshoptions
setopt NO_BG_NICE
setopt NO_LIST_BEEP
setopt LIST_PACKED
setopt MULTIBYTE
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt NO_HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt TRANSIENT_RPROMPT
COMPLETION_WAITING_DOTS="true"

export GIT_PAGER='less -FRX'

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew bundler gem rails rake rvm osx vi-mode)

source $ZSH/oh-my-zsh.sh

# postgresql.app command line tools:
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/Workspace/go_workspace
export PATH=$PATH:$GOPATH/bin
eval "$(rbenv init -)"

# Source my custom files after oh-my-zsh so I can override things.
source $HOME/.dotfiles/zsh/aliases
source $HOME/.dotfiles/zsh/functions

# Fix up the Ruby GC to make it faster
export RUBY_GC_HEAP_INIT_SLOTS=2000000
export RUBY_HEAP_FREE_MIN=20000
export RUBY_GC_MALLOC_LIMIT=100000000

# this helps with source highlighting with less
LESSPIPE=`which src-hilite-lesspipe.sh`
if [[ -n LESSPIPE ]]; then
  export LESSOPEN="| ${LESSPIPE} %s"
  export LESS='-R'
  export PATH="/usr/local/bin:$PATH"
fi

export PRY_THEME=dark

#this is important for all things in life:
export COLLATION=utf8_general_ci


# from https://blog.kumina.nl/2009/11/gpg-agent-on-macosx/
# Script for ensuring only one instance of gpg-agent is running
# and if there is not one, start an instance of gpg-agent.
#if test -f $HOME/.gpg-agent-info && kill -0 `cut -d: -f 2 $HOME/.gpg-agent-info` 2>/dev/null; then
#  GPG_AGENT_INFO=`cat $HOME/.gpg-agent-info`
#  export GPG_AGENT_INFO
#else
#  eval `gpg-agent --daemon`
#  echo $GPG_AGENT_INFO >$HOME/.gpg-agent-info
#fi
# Imperative that this environment variable always reflects the output
# of the tty command.
GPG_TTY=`tty`
export GPG_TTY
export EDITOR=/usr/local/bin/vim
eval $(thefuck --alias)
export RBENV_VERSION=2.3.1

bindkey "^R" history-incremental-search-backward

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh


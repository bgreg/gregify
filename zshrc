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
plugins=(git brew bundler gem rails rake rvm osx)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

if type rvm  >& /dev/null
then
  export PATH=:$HOME/.rvm/bin:~:/usr/local/git/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:$HOME/.bin:$HOME/.rvm/bin:/opt/local/bin:/opt/local/sbin:$PATH
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
elif type rbenv >& /dev/null
then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
else
  echo "no ruby manager installed"
fi


export PATH="$PATH:~/workspace/blackbox/bin"
export PATH="$PATH:/usr/local/opt/mysql55/bin"
# Source my custom files after oh-my-zsh so I can override things.
source $HOME/.dotfiles/zsh/aliases
source $HOME/.dotfiles/zsh/functions

# Fix up the Ruby GC to make it faster
export RUBY_GC_HEAP_INIT_SLOTS=1250000
export RUBY_HEAP_SLOTS_INCREMENT=100000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=30000000
export RUBY_HEAP_FREE_MIN=12500

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
if test -f $HOME/.gpg-agent-info && kill -0 `cut -d: -f 2 $HOME/.gpg-agent-info` 2>/dev/null; then
  GPG_AGENT_INFO=`cat $HOME/.gpg-agent-info`
  export GPG_AGENT_INFO
else
  eval `gpg-agent --daemon`
  echo $GPG_AGENT_INFO >$HOME/.gpg-agent-info
fi
# Imperative that this environment variable always reflects the output
# of the tty command.
GPG_TTY=`tty`
export GPG_TTY
export EDITOR=/usr/local/bin/vim

function clear_desktop() {
  if find "$HOME/Desktop" -maxdepth 1 -type f | grep -v '/\.' &>/dev/null
  then
    DATE=$(date | tr " " "_")
    FILENAME="desktop_backup_$DATE"
    TMP="$HOME/Desktop/tmp_$DATE"
    NEW_PATH="$HOME/Documents/$FILENAME"

    # Move desktop files that are not hidden into a tmp folder
    mkdir $TMP
    find "$HOME/Desktop" -not -path "$HOME/Desktop/.*" -maxdepth 1 -type f -exec mv {} $TMP \;

    # move tmp folder to documents and rename it
    mv $TMP $NEW_PATH
    echo "Desktop files were moved to: $NEW_PATH"
  fi
}

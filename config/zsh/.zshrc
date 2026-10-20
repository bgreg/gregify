# XDG Base Directory Specification is set in ~/.zshenv

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export RBENV_ROOT="$XDG_CONFIG_HOME/rbenv"

source "$ZDOTDIR/omz-settings.zsh"
source $ZSH/oh-my-zsh.sh

# Docker configuration
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
fpath=($DOCKER_CONFIG/completions $fpath)
autoload -Uz compinit
compinit

export NVM_DIR="$XDG_CONFIG_HOME/nvm"
source "$(brew --prefix)/opt/nvm/nvm.sh"
load-nvmrc

export EDITOR=nvim
export VISUAL=nvim

# FZF fuzzy finder
[ -f "$XDG_CONFIG_HOME/fzf/fzf.zsh" ] && source "$XDG_CONFIG_HOME/fzf/fzf.zsh"

# iTerm2 shell integration (required for automatic profile switching)
if [[ "$TERM_PROGRAM" != "vscode" ]] && [[ -z "$CLAUDECODE" ]]; then
  test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" && source "${ZDOTDIR}/.iterm2_shell_integration.zsh"
fi

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

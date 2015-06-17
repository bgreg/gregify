function project_prompt() {
	# If this is under the projects directory, remove ~/projects
	if [[ "$(pwd)" == *"/projects/"* ]]
	then
		path=$(pwd | sed -e "s,^$HOME/projects/, ,")
	else
		path=$(pwd | sed -e "s,^$HOME,~,")
	fi

	echo ${path}
}

PROMPT='%{$fg_bold[red]%}➜%{$fg_bold[green]%}%p %{$fg[cyan]%} %{$fg_bold[yellow]%}$(rvm_prompt_info) %{$fg[blue]%}$(git_prompt_info)%{$fg[blue]%} % %{$reset_color%}'

RPROMPT='$(project_prompt)'

ZSH_THEME_GIT_PROMPT_PREFIX="±(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# Change the RVM Prompt to only show the version and the 
# gemset and not the patch number or type
ZSH_THEME_RVM_PROMPT_OPTIONS=(v g)

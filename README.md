###Installation

  `brew install ruby-build rbenv postgres vim tree zsh `

  Vim plugins are managed through vundle. You'll need to install vundle to get them.
  
  `git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
  
  `git clone git://github.com/bgreg/gregify ~/.dotfiles`
  
  `cd ~/.dotfiles`
  
  `rake install`

  install the vim plugins: 
  `vim +PluginInstall +qall`

####TODO: 

- [x] make a switch for checking ruby version managers
- [x] edit path, it has some older stuff
- [ ] look at using command key more in vimrc ( <D - ... > ) 

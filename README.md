== Installation

  `brew install ruby-build rbenv postgres vim tree zsh `

  Vim plugins are managed through vundle. You'll need to install vundle to get them.
  `git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle`

  `git clone git://github.com/bgreg/gregify ~/.dotfiles`
  `cd ~/.dotfiles`
  rake install

  install the vim plugins: 
  `vim +PluginInstall +qall`

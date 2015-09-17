" TODO:
"  *) add something to show the marks
"  *) figure out how to exclude files from auto complete
"  *) Change save shortcut to <ctrl>+s
"  *) learn to use g; more

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" :help vundle
call vundle#begin()
  Plugin 'sunaku/vim-ruby-minitest'
  Plugin 'gmarik/Vundle.vim'
  Plugin 'bgreg/vim-darknight'
  Plugin 'kien/ctrlp.vim'
  Plugin 'scrooloose/nerdtree.git'
  Plugin 'godlygeek/tabular'
  Plugin 'rking/ag.vim'
  Plugin 'gmarik/vundle'
  Plugin 'vim-ruby/vim-ruby'
  Plugin 'tpope/vim-repeat.git'
  Plugin 'tpope/vim-rails'
  Plugin 'tpope/vim-surround'
  Plugin 'tpope/vim-endwise'
  Plugin 'tpope/vim-unimpaired'
  Plugin 'tpope/vim-commentary'
  Plugin 'tpope/vim-bundler'
  Plugin 'tpope/vim-fugitive'
  Plugin 'thoughtbot/vim-rspec'
  Plugin 'Keithbsmiley/rspec.vim'
  Plugin 'tpope/vim-haml'
  Plugin 'cakebaker/scss-syntax.vim'
  Plugin 'kchmck/vim-coffee-script'
  Plugin 'ervandew/supertab'
  Plugin 'mattn/emmet-vim' "<c-y>, to fire
  Plugin 'kien/rainbow_parentheses.vim'
  Plugin 'bling/vim-airline'
  Plugin 'majutsushi/tagbar'
  Plugin 'myusuf3/numbers.vim'
  Plugin 'edsono/vim-matchit'
  Plugin 'nathanaelkane/vim-indent-guides'
  Plugin 'ecomba/vim-ruby-refactoring'
  Plugin 'xolox/vim-misc'
  Plugin 'scrooloose/syntastic'
  Plugin 'roman/golden-ratio'
  Plugin 'tpope/vim-vividchalk'
  Plugin 'chriskempson/vim-tomorrow-theme'
  Plugin 'guns/xterm-color-table.vim'
call vundle#end()

au VimEnter * RainbowParenthesesToggle
au FileType ruby,eruby setl ofu=rubycomplete#Complete
au FileType html,xhtml setl ofu=htmlcomplete#CompleteTags
au FileType css setl ofu=csscomplete#CompleteCSS

set shiftround
set autowrite
set number
set relativenumber
set ruler
" set spell spelllang=en_us
set ignorecase
set smartcase
set incsearch
set hlsearch
set grepprg=ag
set showmatch " show matching brace when they are typed or under cursor
set matchtime=30
set scrolloff=8
set sidescrolloff=15
set sidescroll=1
set iskeyword-=_,#
set splitbelow
set splitright
set noesckeys
set ttimeout
set ttimeoutlen=1
set timeoutlen=500 " Don't wait so long for the next key press (particularly in ambigious Leader
set autoindent
set smartindent
set autoread
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set backspace=indent,eol,start "Allow backspace in insert mode
set nowrap
set linebreak
set history=500
set undolevels=150 " Save text state between reloads (e.g. if you use :e!)
set undoreload=200
set undodir=$HOME/.vim/undo
set mouse=nicr "enables mouse scrolling
set mouse=a
set t_Co=256
set guifont=Source\ Code\ Pro:h16
set noswapfile
set nobackup
set nowb
set title
set showcmd
set showmode
set gcr=a:blinkon0
set laststatus=2
set runtimepath^=~/.vim/bundle/ctrlp.vim
set nocompatible


let mapleader = ","
let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**;rdoc/**"
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
let g:ctrlp_map='<Leader>t'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|log|sql)$'
  \ }
let g:indent_guides_auto_colors = 0
let g:numbers_exclude = ['tagbar', 'gundo', 'minibufexpl', 'nerdtree']

if &term=~"xterm"
   " colorscheme Tomorrow-Night-Eighties
   colorscheme gotham256
   " These changes only apply to the gotham theme
   highlight LineNr ctermfg=DarkGrey ctermbg=black
   highlight Comment ctermfg=232
   highlight Search cterm=NONE ctermfg=black ctermbg=DarkGrey
   highlight VertSplit ctermfg=black ctermbg=DarkGrey
   highlight Pmenu ctermbg=238 gui=bold
   highlight IndentGuidesOdd  ctermbg=17
   highlight IndentGuidesEven ctermbg=239
endif

"+=================+
"|  Mappings       |
"+=================+
map <Leader>as :call RunCurrentSpecFile()<CR>
map <leader>s :call RunNearestSpec()<CR>
map <leader>l :call RunLastSpec()<CR>
map <leader>a :call RunAllSpecs()<CR>
map <leader>n :NumbersToggle<cr>
map <leader>e :edit %%
map <leader>w :%s/\s\+$//g <cr>
map <leader>f :s/:\([^ ]*\)\(\s*\)=>/\1:/g <cr>
map <leader>y "+yy
map <leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>
map <leader>c :Tabularize /
map <leader>tm :CtrlP app/models/<cr>
map <leader>ta :CtrlP app/assets/<cr>
map <leader>ts :CtrlP spec/<cr>
map <leader>tf :CtrlP spec/fixtures/<cr>
map <leader>tc :CtrlP app/controllers/<cr>
map <leader>tl :CtrlP app/lib/<cr>
map <leader> obyebug<ESC>
nnoremap <leader>rap  :RAddParameter<cr>
nnoremap <leader>rcpc :RConvertPostConditional<cr>
nnoremap <leader>rel  :RExtractLet<cr>
vnoremap <leader>rec  :RExtractConstant<cr>
vnoremap <leader>relv :RExtractLocalVariable<cr>
nnoremap <leader>rit  :RInlineTemp<cr>
vnoremap <leader>rrlv :RRenameLocalVariable<cr>
vnoremap <leader>rriv :RRenameInstanceVariable<cr>
vnoremap <leader>rem  :RExtractMethod<cr>

"
"     Control Mappings
map <c-n> :call RenameFile()<cr>
map <c-\> :NERDTreeFind<cr>
map <c-t> <esc>:tabnew <cr>
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

"
"     command mode
cnoremap %% <C-R>=expand('%:h').'/'<cr>
command! Q q
command! Qall qall

"
"     function keys
nmap <F8>  :TagbarToggle<CR>
map <F8>   :call SwitchColor(1)<CR>
imap <F8>  <Esc>:call SwitchColor(1)<CR>
map <S-F8> :call SwitchColor(-1)<CR>

"
"     Saving
map <Esc><Esc> :w<CR>
" map <c-s> :echo "saved!"<cr>
" map <c-S> :wq <cr>

"
"     other
map <space> :noh<CR>
map ss :sp <CR>
map vv :vsp <CR>
map Q <Nop>         " Disable Ex mode
map Q :q<CR>
vmap Q :q<CR>       " Visual mapping
nnoremap <leader><leader> :w<CR><c-^>  " Switch between the last two files
nnoremap th  :tabfirst <CR>
nnoremap tj  :tabnext <CR>
nnoremap tk  :tabprev <CR>
nnoremap tl  :tablast <CR>
nnoremap te  :tabedit <Space>
nnoremap tn  :tabnext <CR>
nnoremap tm  :tabm <Space>
nnoremap td  :tabclose <CR>
map K <Nop>



"+=============+
"|  Functions  |
"+=============+

function! RenameFile()
let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction

"+================+
"|  Autocommands  |
"+================+

" This autocommand jumps to the last known position in a file
" just after opening it, if the '" mark is set: >
autocmd! BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

"+===========================+
" Custom color switcher      |
"+===========================+

if v:version < 700 || exists('loaded_switchcolor') || &cp
  finish
endif

let loaded_switchcolor = 1

let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
let s:swcolors = map(paths, 'fnamemodify(v:val, ":t:r")')
let s:swskip = [ '256-jungle', '3dglasses', 'calmar256-light', 'coots-beauty-256', 'grb256' ]
let s:swback = 0    " background variants light/dark was not yet switched
let s:swindex = 0

function! SwitchColor(swinc)
  " if have switched background: dark/light
  if (s:swback == 1)
    let s:swback = 0
    let s:swindex += a:swinc
    let i = s:swindex % len(s:swcolors)

    " in skip list
    if (index(s:swskip, s:swcolors[i]) == -1)
      execute "colorscheme " . s:swcolors[i]
    else
      return SwitchColor(a:swinc)
    endif

  else
    let s:swback = 1
    if (&background == "light")
      execute "set background=dark"
    else
      execute "set background=light"
    endif

    " roll back if background is not supported
    if (!exists('g:colors_name'))
      return SwitchColor(a:swinc)
    endif
  endif

  " show current name on screen. :h :echo-redraw
  redraw
  execute "colorscheme"
endfunction

filetype on
filetype plugin on
filetype indent on
syntax enable


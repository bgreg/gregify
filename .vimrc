" TODO: 
"  add something to show the marks
"  read this: http://robots.thoughtbot.com/faster-grepping-in-vim
"  figure out how to exclude files from auto complete
"  Figure out system clipboard thing

set nocompatible " call  Use VIM, not VI
filetype off
execute pathogen#infect()
execute pathogen#helptags()




"===============================================================
"
" Vim Configuration changes
"
"===============================================================

" ignore case when searching
set ignorecase 

" case sensitive only when capital letter in expression
set smartcase 

" show matches as they are found
set incsearch 

set hlsearch
" Use Silver Searcher instead of grep
set grepprg=ag
" Fuzzy finder: ignore stuff that can't be opened, and generated files
let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**;rdoc/**"


" Toggle search highlighting
nnoremap <Leader>h :noh <CR>

" show matching brace when they are typed or under cursor
set showmatch 

" length of time for 'showmatch'
set matchtime=30 

set scrolloff=8
set sidescrolloff=15
set sidescroll=1

" Use _ as a word-separator
set iskeyword-=_,#

map ss :sp <CR>
map vv :vsp <CR>
set splitbelow
set splitright

" (Hopefully) removes the delay when hitting esc in insert mode
set noesckeys
set ttimeout
set ttimeoutlen=1

" Don't wait so long for the next keypress (particularly in ambigious Leader
set timeoutlen=500

set autoindent
set smartindent
set autoread
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
 "Allow backspace in insert mode
set backspace=indent,eol,start 
set nowrap
set linebreak

filetype plugin on
filetype indent on


" Don't need to go nuts with the undo level, 150 should be fine
set history=500 

" Save text state between reloads (e.g. if you use :e!)
set undolevels=150

" Undo levels between sessions!
set undoreload=200 
set undodir=$HOME/.vim/undo

syntax enable
set mouse=nicr " enables mouse scrolling
set mouse=a
set t_Co=256
let g:solarized_termcolors=256

if &term=~"xterm"
   set background=dark
   colorscheme gotham

   " Custom color changes to the gotham theme
   highlight LineNr ctermfg=DarkGrey ctermbg=black
   highlight Comment ctermfg=232
   highlight Search cterm=NONE ctermfg=black ctermbg=DarkGrey
   highlight VertSplit ctermfg=black ctermbg=DarkGrey
else
  set background=dark
  colorscheme solarized
endif

set guifont=Source\ Code\ Pro:h16

" Turn off swap files
set noswapfile
set nobackup
set nowb



"===============================================================
"
" Basic Vim Command re mappings 
"
"===============================================================

"--------------------
"     leader key
"--------------------
let mapleader = ","

"--------------------
"     reload vimrc
"--------------------
map <Leader>r :so $MYVIMRC <cr>

"debug
map <Leader>d <cr>byebug<esc>:w<cr>

" system clipboard paste
map <Leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>

"saving
map <C-w> <esc>:w<CR>
" and in insert mode
imap <C-w> <esc>:w<CR>

"ZZ to save and quit


" tabs
map <C-t> <esc>:tabnew<CR>
nnoremap th  :tabfirst <CR>
nnoremap tj  :tabnext <CR>
nnoremap tk  :tabprev <CR>
nnoremap tl  :tablast <CR>
nnoremap tt  :tabedit <Space>
nnoremap tn  :tabnext <CR>
nnoremap tm  :tabm <Space>
nnoremap td  :tabclose <CR>

"--------------------
" fix old ruby hash
"--------------------
map <Leader>f :%s/:\([^ ]*\)\(\s*\)=>/\1:/g <cr>

"--------------------
" split navigation
" :help splits
"--------------------
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

" Disable EX mode
map Q <Nop>

" When at 3 spaces and I hit >>, go to 4, not 5.
set shiftround 

" disable looking stuff up
map K <Nop>         

" set the title to the file name and modification status
set title           

" show the command being typed
set showcmd         

" show current mode (insert, visual, etc.)
set showmode        

"Disable cursor blink
set gcr=a:blinkon0  

" always show status line 
set laststatus=2    







"===============================================================
"
" Vundle settup, and package specific settings
"
"===============================================================

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim' " let Vundle manage Vundle, required
call vundle#end()       

"==========================
"        Ctrl-P
"==========================
Bundle 'kien/ctrlp.vim' 
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map='<Leader>t'
let g:ctrlp_cmd = 'CtrlP'

" Leader-b opens up CtrlP for buffers
nmap <silent> <Leader>b :CtrlPBuffer<CR>
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|log|sql)$'
  \ }

"--------------------
" Nerd Tree
"--------------------
Bundle 'scrooloose/nerdtree.git'
map <c-\> :NERDTreeFind<CR>

"--------------------
" Tabular
" vertical alignment helper
"--------------------
Bundle 'godlygeek/tabular'      
map <c-A> :Tabularize /

"--------------------
" autocomplete
"--------------------
filetype plugin on
au FileType ruby,eruby setl ofu=rubycomplete#Complete
au FileType html,xhtml setl ofu=htmlcomplete#CompleteTags
au FileType css setl ofu=csscomplete#CompleteCSS

" default color is crazy
highlight Pmenu ctermbg=238 gui=bold       

" faster file searching
Bundle 'rking/ag.vim'

" In the quickfix window, you can use:
"     e    to open file and close the quickfix window
"     o    to open (same as enter)
"     go   to preview file (open but maintain focus on ag.vim results)
"     t    to open in new tab
"     T    to open in new tab silently
"     h    to open in horizontal split
"     H    to open in horizontal split silently
"     v    to open in vertical split
"     gv   to open in vertical split silently
"     q    to close the quickfix window

Bundle 'gmarik/vundle'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-repeat.git'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-bundler' 
Bundle 'tpope/vim-fugitive'
" Provides Rspec runners
Bundle 'thoughtbot/vim-rspec'  

" Provides syntax highlighting for rspec
Bundle 'Keithbsmiley/rspec.vim'
map <Leader>as :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Haml
Bundle 'tpope/vim-haml'
"Sass
Bundle 'cakebaker/scss-syntax.vim'

"coffee script
Bundle 'kchmck/vim-coffee-script'
"autocomplete helper
Bundle 'ervandew/supertab'
"html autocomplete engine
"<c-y>, to fire
Bundle 'mattn/emmet-vim'

"  This is cool, but it slows down rendering significantly 
Bundle 'kien/rainbow_parentheses.vim'
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
" I don't know what these really do
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

" set the syntax highlighters on at launch
au VimEnter * RainbowParenthesesToggle

" This is a lightweight vim status bar
Bundle 'bling/vim-airline'      
let g:airline_detect_whitespace=0 


" Tag bar
Bundle  'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>

" Numbers
Bundle "myusuf3/numbers.vim"
set number          " Line number
set relativenumber  " show the line numbers relative to current position
set ruler           " always show the current position
let g:numbers_exclude = ['tagbar', 'gundo', 'minibufexpl', 'nerdtree']
noremap <Leader>n :NumbersToggle<cr> " Toggle between relative numbers and absolute numbers
nnoremap <F3> :NumbersToggle<CR>
nnoremap <F4> :NumbersOnOff<CR>

" Matching  % in many more scenarios
Bundle 'edsono/vim-matchit'

" indent guide, useful for white space delimited languages
Bundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=17
hi IndentGuidesEven ctermbg=239

"=================================================================================
"
" Functions
" 
"=================================================================================

"------------------------------------------------------------------------------
" RENAME CURRENT FILE (thanks Gary Bernhardt)
"------------------------------------------------------------------------------
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <C-n> :call RenameFile()<cr>


" TODO: 
"  add something to show the marks
"  read this: http://robots.thoughtbot.com/faster-grepping-in-vim
"  figure out how to exclude files from auto complete
"  add indent guide plugin
"
"  Figure out system clipboard thing
"

set nocompatible " call  Use VIM, not VI
filetype off

let mapleader = ","

execute pathogen#infect()
execute pathogen#helptags()

"================================================================
" Vundle setup
" bootstrap vundle here, then use bundles at bottom to add new stuff
"==============================================================
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim' " let Vundle manage Vundle, required
call vundle#end()       

"==========================
" reload vimrc
"==========================
map <Leader>r :so $MYVIMRC <cr>


"==========================
"Ctrl-P
"==========================
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map='<Leader>t'
let g:ctrlp_cmd = 'CtrlP'

" Leader-b opens up CtrlP for buffers
nmap <silent> <Leader>b :CtrlPBuffer<CR>
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|log|sql)$'
  \ }

"==========================
" split navigation
" p>         " disable looking stuff up
" :help splits
"==========================
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
"
" Use ctrl-[hjkl] to select the active split!
" nmap <silent> <c-k> :wincmd k<CR>                                                                                                                       
" nmap <silent> <c-j> :wincmd j<CR>                                                                                                                       
" nmap <silent> <c-h> :wincmd h<CR>                                                                                                                       
" nmap <silent> <c-l> :wincmd l<CR>

map <up> <C-w><up>
map <down> <C-w><down>
map <left> <C-w><left>
map <right> <C-w><right>

set splitbelow
set splitright

"--------------------
"Editing 
"--------------------
set autoindent
set smartindent
set autoread
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set backspace=indent,eol,start  "Allow backspace in insert mode
set nowrap
set linebreak

filetype plugin on
filetype indent on


"--------------------
" fix old ruby hash
"--------------------
map <Leader>f :%s/:\([^ ]*\)\(\s*\)=>/\1:/g <cr>

"--------------------
" History
"--------------------
set history=500    " Don't need to go nuts with the undo level, 150 should be fine
set undolevels=150 " Save text state between reloads (e.g. if you use :e!)
set undoreload=200 " Undo levels between sessions!
set undodir=$HOME/.vim/undo

"--------------------
" Interface
"--------------------
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

" --- Turn off swap files
set noswapfile
set nobackup
set nowb

command! Q q " Bind :Q to :q
command! W w " Bind :W to :w
command! Qall qall 
set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.

map Q :q <CR>
map W :w <CR>
map K <Nop>         " disable looking stuff up
set title           " set the title to the file name and modification status
set showcmd         " show the command being typed
set showmode        " show current mode (insert, visual, etc.)
set gcr=a:blinkon0  "Disable cursor blink
set laststatus=2    " always show status line 
" set colorcolumn=80 " Highlight column 80 so I know when to wrap
" Change the 80th char column to be grey instead of red
" autmcmd ColorScheme * highlight ColorColumn guibg=Gray20

"--------------------
" Nerd Tree
"--------------------
map <c-\> :NERDTreeFind<CR>

"--------------------
" Tabular
"--------------------
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

"--------------------
" Searching
"--------------------
set ignorecase " ignore case when searching
set smartcase " case sensitive only when capital letter in expression
set incsearch " show matches as they are found
set hlsearch
" Use Silver Searcher instead of grep
set grepprg=ag
" Fuzzy finder: ignore stuff that can't be opened, and generated files
let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**;rdoc/**"


" Toggle search highlighting
nnoremap <Leader>h :noh <CR>

"--------------------
"  Feedback
"--------------------
 set showmatch " show matching brace when they are typed or under cursor
 set matchtime=30 " length of time for 'showmatch'

" set this to a function
":so $MYVIMRC
 

"--------------------
" Naigation
"--------------------
set scrolloff=8
set sidescrolloff=15
set sidescroll=1


" Use _ as a word-separator
set iskeyword-=_,#

map ss :sp <CR>
map vv :vsp <CR>

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



" add bundles here
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

Bundle 'scrooloose/nerdtree.git'
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
" Fuzzy file filder
Bundle 'kien/ctrlp.vim' 
 " Provides syntax highlighting for rspec
Bundle 'Keithbsmiley/rspec.vim'


" vertical alignment helper
Bundle 'godlygeek/tabular'      


" TODO reorganize things down here:
"----------
" Language
"-----------

" Haml
Bundle 'tpope/vim-haml'

"Sass
Bundle 'cakebaker/scss-syntax.vim'


"----------------------------
" Completion
"-----------------------------

"autocomplete helper
Bundle 'ervandew/supertab'

"----------------------------------------
" Code display
"----------------------------------------
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


"----------------------------------------
" Integrations
"----------------------------------------

"----------------------------------------
" Interface
"----------------------------------------
"
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

" Ruby matchit
" Non bundle
" this matches do/end in ruby, but it isn't in bundle controll: ruby-matchit.vim
"

" tabs
" :tabnew
nnoremap th  :tabfirst <CR>
nnoremap tj  :tabnext <CR>
nnoremap tk  :tabprev <CR>
nnoremap tl  :tablast <CR>
nnoremap tt  :tabedit <Space>
nnoremap tn  :tabnext <CR>
nnoremap tm  :tabm <Space>
nnoremap td  :tabclose <CR>



"----------
" Commands
"-----------

"==========================
" RSpec.vim mappings
"==========================
map <Leader>as :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

"--------------------
" Performance 
"--------------------

" (Hopefully) removes the delay when hitting esc in insert mode
set noesckeys
set ttimeout
set ttimeoutlen=1

" Don't wait so long for the next keypress (particularly in ambigious Leader
" situations.
set timeoutlen=500


"----------
" Other
"-----------

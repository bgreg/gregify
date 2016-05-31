" TODO:
"  *) add something to show the marks
"  *) figure out how to exclude files from auto complete
"  *) if it is before 12 am, use morning color scheme
"  *)  https://github.com/mhinz/vim-grepper

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
set encoding=utf-8

" :help vundle
call vundle#begin()
  Plugin 'sunaku/vim-ruby-minitest'
  Plugin 'gmarik/Vundle.vim'
  Plugin 'whatyouhide/vim-gotham'
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
  Plugin 'bling/vim-airline'
  Plugin 'majutsushi/tagbar'
  Plugin 'myusuf3/numbers.vim'
  Plugin 'edsono/vim-matchit'
  Plugin 'nathanaelkane/vim-indent-guides'
  Plugin 'ecomba/vim-ruby-refactoring'
  Plugin 'xolox/vim-misc'
  Plugin 'scrooloose/syntastic'
  Plugin 'tpope/vim-vividchalk'
  Plugin 'chriskempson/vim-tomorrow-theme'
  Plugin 'guns/xterm-color-table.vim'
  Plugin '907th/vim-auto-save'
  Plugin 'roman/golden-ratio'
  Plugin 'ngmy/vim-rubocop'
call vundle#end()

au FileType ruby,eruby setl ofu=rubycomplete#Complete
au FileType html,xhtml setl ofu=htmlcomplete#CompleteTags
au FileType css setl ofu=csscomplete#CompleteCSS

set shiftround
set autowrite
set number
set relativenumber
set ruler
set spell spelllang=en_us
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
set timeoutlen=500 " Don't wait so long for the next key press
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
set history=1000
set undolevels=500 " Save text state between reloads (e.g. if you use :e!)
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
" set hidden " navigate away from a buffer without saving
let mapleader = "\<Space>"
let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**;rdoc/**"
let g:ctrlp_map='<Leader>t'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|log|sql)$'
  \ }
let g:indent_guides_auto_colors = 0
let g:numbers_exclude = ['tagbar', 'gundo', 'minibufexpl', 'nerdtree']
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode

" let g:user_emmet_leader_key='<C-j>'  this didn't work because I hit that to
" move windows

colorscheme gotham256

" let g:alduin_Shout_Windhelm = 1
" colorscheme alduin

" if &term=~"xterm"
"    " These changes only apply to the gotham theme
"    highlight LineNr ctermfg=DarkGrey ctermbg=black
"    highlight Comment ctermfg=Magenta
"    highlight Search cterm=NONE ctermfg=black ctermbg=DarkGrey
"    highlight VertSplit ctermfg=black ctermbg=DarkGrey
"    highlight Pmenu ctermbg=238 gui=bold
"    highlight IndentGuidesOdd  ctermbg=5
"    highlight IndentGuidesEven ctermbg=13


"    " highlight Comment ctermbg=DarkGray
"    " highlight Constant ctermbg=Blue
"    " highlight Normal ctermbg=Black
"    " highlight NonText ctermbg=Black
"    " highlight Special ctermbg=DarkMagenta
"    " highlight Cursor ctermbg=Green
" endif

"+=================+
"|  Mappings       |
"+=================+

map <Leader>as :call RunCurrentSpecFile()<CR>
map <leader>s :call RunNearestSpec()<CR>
map <leader>l :call RunLastSpec()<CR>
map <leader>a :call RunAllSpecs()<CR>
map <leader>e :edit %%
map <leader>w :call WrapThem()<cr>
map <leader>f :s/:\([^ ]*\)\(\s*\)=>/\1:/g <cr>
map <leader>y "+yy
map <leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>
map <leader>c :Tabularize /
map <leader>tm :CtrlP app/models/<cr>
map <leader>ta :CtrlP app/assets/<cr>
map <leader>ts :CtrlP spec/<cr>
map <leader>tf :CtrlP spec/fixtures/<cr>
map <leader>tc :CtrlP app/controllers/<cr>
map <leader>tv :CtrlP app/views/<cr>
map <leader>tl :CtrlP app/lib/<cr>
map <leader>ig :IndentGuidesToggle<cr>
map <leader>b :bp <cr>
map <leader>n :bn <cr>

" refactoring bindings
nnoremap <leader>rap  :RAddParameter<cr>
nnoremap <leader>rcpc :RConvertPostConditional<cr>
nnoremap <leader>rel  :RExtractLet<cr>
vnoremap <leader>rec  :RExtractConstant<cr>
vnoremap <leader>relv :RExtractLocalVariable<cr>
nnoremap <leader>rit  :RInlineTemp<cr>
vnoremap <leader>rrlv :RRenameLocalVariable<cr>
vnoremap <leader>rriv :RRenameInstanceVariable<cr>
vnoremap <leader>rem  :RExtractMethod<cr>

"     Control Mappings
map <c-n> :call RenameFile()<cr>
map <c-\> :NERDTreeFind<cr>
map <c-t> <esc>:tabnew <cr>
map <c-c><c-t> <esc>:!ctags -R .<cr>
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

"     Command mode
cnoremap %% <C-R>=expand('%:h').'/'<cr>
command! Q q
command! Qall qall

"     Function keys
nmap <F7> :TagbarToggle<CR>
map  <F8> :call SwitchColor(1)<CR>
imap <F8> <Esc>:call SwitchColor(1)<CR>
map  <S-F8> :call SwitchColor(-1)<CR>

"     Other
map <space> :noh<CR>
map ss :sp <CR>
map vv :vsp <CR>
map K <Nop>
map Q <Nop>         " Disable Ex mode
map Q :q<CR>        " quit in normal mode
vmap Q :q<CR>       " quit in visual mapping
nnoremap , :w<CR><c-^>  " Switch between the last two files
nnoremap <leader>fs 1z=  " pick the first option to correct spelling mistakes

"    Tab navigation
nnoremap th  :tabfirst <CR>
nnoremap tj  :tabnext <CR>
nnoremap tk  :tabprev <CR>
nnoremap tl  :tablast <CR>
nnoremap tn  :tabnext <CR>
nnoremap tm  :tabm <Space>
nnoremap td  :tabclose <CR>
nnoremap <leader>wtf oputs "#" * 90<c-m>puts caller<c-m>puts "#" * 90<esc>
nnoremap <leader>bi o<c-m>binding.pry<c-m><esc>

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

" Remove white space on save
autocmd BufWritePre * :%s/\s\+$//e

" Play song for directory
autocmd BufReadPost * call Spotify()

function! Spotify()
  let file_name = expand('%:p:h')
  exec ':silent !~/.dotfiles/soundtrack ' . file_name
  redraw!
endfunction

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

filetype plugin indent on
syntax enable

"+===========================+
"  Wrap things in a character|
"+===========================+
let g:wrap_char = '#'
function! WrapThem() range
		let lines = getline(a:firstline,a:lastline)
		let maxl = 0
		for l in lines
				let maxl = len(l)>maxl? len(l):maxl
		endfor
		let h = repeat(g:wrap_char, maxl+4)
		for i in range(len(lines))
				let ll = len(lines[i])
				let lines[i] = g:wrap_char . ' ' . lines[i] . repeat(' ', maxl-ll) . ' ' . g:wrap_char
		endfor
		let result = [h]
		call extend(result, lines)
		call add(result,h)
		execute a:firstline.','.a:lastline . ' d'
		let s = a:firstline-1<0?0:a:firstline-1
		call append(s, result)
endfunction


"+===========================+
" Macros                     |
"+===========================+

" puts a var
let @p='ywoputs ""hpli: #{}hp^'

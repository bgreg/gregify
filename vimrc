" TODO:
"  *) if it is before 12 am, use morning color scheme

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
set encoding=utf-8

" :help vundle
call vundle#begin()
  Plugin 'gmarik/Vundle.vim'
  Plugin 'whatyouhide/vim-gotham'
  Plugin 'ctrlpvim/ctrlp.vim'
  Plugin 'scrooloose/nerdtree.git'
  Plugin 'godlygeek/tabular'
	Plugin 'mhinz/vim-grepper'
  Plugin 'vim-ruby/vim-ruby'
	Plugin 'elixir-lang/vim-elixir'
	Plugin 'avdgaag/vim-phoenix'
  Plugin 'tpope/vim-repeat.git'
  Plugin 'tpope/vim-rails'
  Plugin 'tpope/vim-surround'
  Plugin 'tpope/vim-endwise'
  Plugin 'tpope/vim-unimpaired'
  Plugin 'tpope/vim-commentary'
  Plugin 'tpope/vim-bundler'
  Plugin 'tpope/vim-fugitive'
  Plugin 'tpope/vim-ragtag'
  Plugin 'tpope/vim-dispatch'
  Plugin 'keith/rspec.vim'
  Plugin 'cakebaker/scss-syntax.vim'
  Plugin 'kchmck/vim-coffee-script'
  Plugin 'mattn/emmet-vim' "<c-y>, to fire
  Plugin 'ervandew/supertab'
  Plugin 'bling/vim-airline'
  Plugin 'majutsushi/tagbar'
  Plugin 'myusuf3/numbers.vim'
	Plugin 'tmhedberg/matchit'
  Plugin 'ecomba/vim-ruby-refactoring'
  Plugin 'xolox/vim-misc'
  Plugin 'chriskempson/vim-tomorrow-theme'
  Plugin 'guns/xterm-color-table.vim'
  Plugin '907th/vim-auto-save'
  Plugin 'roman/golden-ratio'
  Plugin 'ngmy/vim-rubocop'
  Plugin 'tommcdo/vim-exchange'
  Plugin 'lifepillar/vim-solarized8'
	Plugin 'junegunn/gv.vim'
	Plugin 'vim-scripts/DrawIt'
	Plugin 'MarcWeber/vim-addon-mw-utils'
	Plugin 'tomtom/tlib_vim'
	Plugin 'garbas/vim-snipmate' " Pure vim script snippets, using this because utilisnips needs python and youcompleteme
	Plugin 'honza/vim-snippets'
  Plugin 'w0rp/ale'
  Plugin 'janko-m/vim-test'
	Plugin 'skywind3000/asyncrun.vim'
	Plugin 'jyota/vimColors'
  Plugin 'muellan/am-colors'
	Plugin 'kassio/neoterm'
	Plugin 'Yggdroot/indentLine'
call vundle#end()

filetype plugin indent on
syntax enable

au FileType ruby,eruby setl ofu=rubycomplete#Complete
au FileType html,xhtml setl ofu=htmlcomplete#CompleteTags
au FileType css setl ofu=csscomplete#CompleteCSS

set shiftround
set autowriteall
set number
set relativenumber
" set spell spelllang=en_us " set nospell
set ignorecase
set smartcase
set grepprg=ag
" set showmatch " show matching brace when they are typed or under cursor
set matchtime=30
set scrolloff=8
set sidescrolloff=15
set sidescroll=1
set splitbelow
set splitright
" set noesckeys
set ttimeout
set ttimeoutlen=1
set timeoutlen=500 " Don't wait so long for the next key press
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set backspace=indent,eol,start "Allow backspace in insert mode
set nowrap
set linebreak
set history=10000
set undofile
set undolevels=1000 " Save text state between reloads (e.g. if you use :e!)
set undoreload=1000
set mouse=nicr "enables mouse scrolling
set mouse=a
set guifont=Source\ Code\ Pro:h16
set noswapfile
set nobackup
set nowb
set title
set showmode
set gcr=a:blinkon0
set runtimepath^=~/.vim/bundle/ctrlp.vim
set nocompatible
set termguicolors
" enable 24 bit color support
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
set nofoldenable    " disable folding
set tags=./tags,tags
set undodir=$HOME/.vim/undo
set smarttab
set showcmd
set autoindent
set autoread
set hlsearch
set incsearch
set laststatus=2
set ruler
set synmaxcol=200  " only syntax highlight the first 200 columns of a line


let mapleader = "\<Space>"
let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**;rdoc/**"

let b:surround_{char2nr('=')} = "<%= \r %>"
let b:surround_{char2nr('-')} = "<% \r %>"

let g:ctrlp_map='<Leader>t'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|log|sql)$'
  \ }

let g:numbers_exclude = ['tagbar', 'gundo', 'minibufexpl', 'nerdtree']
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
let g:golden_ratio_autocommand = 0 " disable on startup

" colorscheme solarized8_dark
colorscheme gotham256
let test#strategy = "neovim"

let g:snipMate = get(g:, 'snipMate', {}) " Allow for vimrc re-sourcing
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['ruby'] = 'ruby,rails'         " look for snippets in both these files at once for ruby files

"+=================+
"|  Mappings       |
"+=================+
" map <Leader>a :call RunCurrentSpecFile()<CR>
" map <leader>s :call RunNearestSpec()<CR>
" map <leader>l :call RunLastSpec()<CR>
" map <leader>as :call RunAllSpecs()<CR>

nmap <silent> <leader>a :TestFile<CR>
nmap <silent> <leader>s :TestNearest<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>as :TestSuite<CR>

map <leader>w :w<cr>
map <leader>sc :vsp db/schema.rb<cr>
map <leader>f :s/:\([^ ]*\)\(\s*\)=>/\1:/g <cr>
map <leader>y "+yy
map <leader>p :set paste<CR><esc>"*]p:set nopaste<cr>
map <leader>c :Tabularize /
map <leader>tm :CtrlP app/models/<cr>
map <leader>ta :CtrlP app/assets/<cr>
map <leader>te :CtrlP app/elements/<cr>
map <leader>ts :CtrlP spec/<cr>
map <leader>tf :CtrlP spec/fixtures/<cr>
map <leader>tc :CtrlP app/controllers/<cr>
map <leader>tv :CtrlP app/views/<cr>
map <leader>tl :CtrlP app/lib/<cr>
map <leader>te :CtrlP app/elements/<cr>
" map <leader>ig :IndentGuidesToggle<cr>
map <leader>b :bp <cr>
map <leader>n :bn <cr>
map <leader>ru :Rubocop <cr>
map <leader>= =am <cr>

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

nnoremap <leader>g :Grepper<cr>
let g:grepper = { 'next_tool': '<leader>g' }

"     Control Mappings
map <c-\> :NERDTreeFind<cr>
map <c-t> <esc>:tabnew <cr>
map <c-c><c-t> <esc>:!ctags -R . --sort=yes<cr>

" Split Pane navigation
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>

nnoremap <C-i> :IndentLinesToggle<cr>
let g:indentLine_enabled = 0  "disable indent guides by default. Use the command to enable them


" Terminal
tnoremap <Leader><ESC> <C-\><C-n>
tnoremap <D-l> clear<CR>

tmap <C-h> <Leader><ESC><C-h>
tmap <C-j> <Leader><ESC><C-j>
tmap <C-k> <Leader><ESC><C-k>
tmap <C-l> <Leader><ESC><C-l>

" Auto insert on terminal

augroup terminal_insert
	autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
augroup END



" Command mode
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

"+================+
"|  Autocommands  |
"+================+


" This autocommand jumps to the last known position in a file
" just after opening it, if the '" mark is set: >
autocmd! BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" turn these off when you want to use drawit
autocmd BufWritePre * :%s/\s\+$//e " Remove white space on save
let g:auto_save = 1  " enable AutoSave on Vim startup

" Play song for directory
" autocmd BufReadPost * call Spotify()
"
"resize splits when window is resized
autocmd VimResized * wincmd =

" function! Spotify()
"   let file_name = expand('%:p:h')
"   exec ':silent !~/.dotfiles/soundtrack ' . file_name
"   redraw!
" endfunction

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

"+===========================+
" Macros                     |
"+===========================+

" puts a var
let @p='ywoputs ""hpi: #{}hp^'

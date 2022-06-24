" ┏┓╻╻ ╻┏━╸┏┓ ╻  ┏━┓┏━╸┏━┓   ┏┓╻╻ ╻╻┏┳┓   ┏━╸┏━┓┏┓╻┏━╸╻┏━╸
" ┃┗┫┃┏┛┣╸ ┣┻┓┃  ┃ ┃┃╺┓┗━┓   ┃┗┫┃┏┛┃┃┃┃   ┃  ┃ ┃┃┗┫┣╸ ┃┃╺┓
" ╹ ╹┗┛ ╹  ┗━┛┗━╸┗━┛┗━┛┗━┛   ╹ ╹┗┛ ╹╹ ╹   ┗━╸┗━┛╹ ╹╹  ╹┗━┛
" Author: NFVblog aka Nicola Ferru
call plug#begin()
	Plug 'ap/vim-css-color'
	Plug 'bling/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'preservim/nerdtree'
	Plug 'fidian/hexmode'
	Plug 'bfrg/vim-cpp-modern'
	Plug 'terryma/vim-multiple-cursors'
	Plug 'fidian/hexmode'
	Plug 'Winseven4lyf/vim-bbcode'
call plug#end()

let mapleader =","
set encoding=utf-8
set number
set mouse=a
set ruler
set list listchars=nbsp:¬,tab:»·,trail:·,extends:>	
set bs=2
set shiftwidth=4
set softtabstop=4
set tabstop=4
syntax on
set relativenumber
set synmaxcol=1000
set viminfo='20,<1000,s1000
set colorcolumn=+1
set cursorline
set textwidth=79
set clipboard+=unnamedplus

" Spell-check set to F6:
	map <F6> :setlocal spell! spelllang=it<CR>

	" Cartelle con funzioni di backup
for directory in ["backup", "swap", "undo"]
	silent! call mkdir($HOME . "~/.config/nvim/" . directory, "p")
		endfor
			set backupdir=~/.config/vim/backup//
			set directory=~/.config/vim/swap//
			set undodir=~/.config/vim/undo//
			set undofile 

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Open my bibliography file in split
	map <F9> :vsp<space>~/Documenti/LaTeX/uni.bib<CR>
	map <leader>b :vsp<space>~/Documenti/LaTeX/uni.bib<CR>

	" Toggle NerdTree with F7:
	nm <F7> :NERDTreeToggle<CR>

	" LaTeX Macros
	so ~/.config/nvim/macros/LaTeX.vim

	" C & C++ Macros
	so ~/.config/nvim/macros/clike.vim

	" HTML, PHP & CSS Macros
	so ~/.config/nvim/macros/web.vim

	" BBcode Macros
	so ~/.config/nvim/macros/bbcode.vim

	" Markdown Macros
	so ~/.config/nvim/macros/markdown.vim

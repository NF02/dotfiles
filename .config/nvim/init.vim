" ▄▄▄   ▄▄  ▄▄▄▄▄▄▄▄                                             ▄▄
" ███   ██  ██▀▀▀▀▀▀                                             ██
" ██▀█  ██  ██         ▄████▄    ██▄████   ██▄████  ██    ██     ▀▀     ▄▄█████▄
" ██ ██ ██  ███████   ██▄▄▄▄██   ██▀       ██▀      ██    ██            ██▄▄▄▄ ▀
" ██  █▄██  ██        ██▀▀▀▀▀▀   ██        ██       ██    ██             ▀▀▀▀██▄
" ██   ███  ██        ▀██▄▄▄▄█   ██        ██       ██▄▄▄███            █▄▄▄▄▄██
" ▀▀   ▀▀▀  ▀▀          ▀▀▀▀▀    ▀▀        ▀▀        ▀▀▀▀ ▀▀             ▀▀▀▀▀▀
"              ██
"              ▀▀
" ██▄  ▄██   ████     ████▄██▄   ██▄████   ▄█████▄
"  ██  ██      ██     ██ ██ ██   ██▀      ██▀    ▀
"  ▀█▄▄█▀      ██     ██ ██ ██   ██       ██
"   ████    ▄▄▄██▄▄▄  ██ ██ ██   ██       ▀██▄▄▄▄█
"    ▀▀     ▀▀▀▀▀▀▀▀  ▀▀ ▀▀ ▀▀   ▀▀         ▀▀▀▀▀

	call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
		Plug 'deviantfero/wpgtk.vim'
		Plug 'dylanaraps/wal'
		Plug 'tpope/vim-surround'
		Plug 'preservim/nerdtree'
		Plug 'junegunn/goyo.vim'
		Plug 'PotatoesMaster/i3-vim-syntax'
		Plug 'jreybert/vimagit'
		Plug 'lukesmithxyz/vimling'
		Plug 'vimwiki/vimwiki'
		Plug 'bling/vim-airline'
		Plug 'vim-airline/vim-airline-themes'
		Plug 'tpope/vim-commentary'
		Plug 'kovetskiy/sxhkd-vim'
		Plug 'ap/vim-css-color'
"		Plug 'terryma/vim-multiple-cursors'
		Plug 'bfrg/vim-cpp-modern'
		Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
		Plug 'dracula/vim'
		Plug 'skanehira/preview-markdown.vim'
	call plug#end()

	"Base
	set nocompatible
	filetype plugin indent on
	syntax on
	set nofoldenable
	set encoding=utf-8
	set number
	set mouse=a
	colorscheme slate
	"set relativenumber
	set title
	set go=a

	set splitbelow
	set splitright

	set list listchars=nbsp:¬,tab:»·,trail:·,extends:>	
	set bs=2
	set ruler
	set shiftwidth=4
	set softtabstop=4
	set tabstop=4
	set noswapfile
	
	set synmaxcol=1000
	set viminfo='20,<1000,s1000
	set colorcolumn=+1
	set cursorline
	set textwidth=79
	set clipboard+=unnamedplus
	let g:airline#extensions#tabline#enabled = 1
	let g:airline_theme='wpgtk'

	inoremap <S-Tab> <C-d>

	nnoremap <silent> <F11> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

	" Cartelle per il corretto punzionamento dell'editor
for directory in ["backup", "swap", "undo"]
	silent! call mkdir($HOME . "/.vim/" . directory, "p")
		endfor
			set backupdir=~/.vim/backup//
			set directory=~/.vim/swap//
			set undodir=~/.vim/undo//
			set undofile

	" Cartella delle note
	 autocmd BufRead,BufNewFile ~/.local/share/nota/* set filetype=markdown

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Open the selected text in a split (i.e. should be a file).
	map <leader>o "oyaW:sp <C-R>o<CR>
	xnoremap <leader>o "oy<esc>:sp <C-R>o<CR>
	vnoremap <leader>o "oy<esc>:sp <C-R>o<CR>

" Open my bibliography file in split
	map <F9> :vsp<space>~/Documenti/LaTeX/uni.bib<CR>
	map <leader>b :vsp<space>~/Documenti/LaTeX/uni.bib<CR>

" Spell-check set to F6:
	map <F6> :setlocal spell! spelllang=it<CR>

	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
" Readmes autowrap text:
	autocmd BufRead,BufNewFile *.md,*.tex set tw=79

" Toggle DeadKeys set (for accent marks):
	nm <leader><leader>d :call ToggleDeadKeys()<CR>
	imap <leader><leader>d <esc>:call ToggleDeadKeys()<CR>a

" Source my IPA shorcuts:
	nm <leader><leader>i :call ToggleIPA()<CR>
	imap <leader><leader>i <esc>:call ToggleIPA()<CR>a

" Use urlview to choose and open a url:
	:noremap <leader>u :w<Home>silent <End> !urlview<CR>
	:noremap ,, :w<Home>silent <End> !urlview<CR>

" Copy selected text to system clipboard (requires gvim installed):
	vnoremap <C-c> "*Y :let @+=@*<CR>
	map <C-p> "+P

" Toggle Prose Mode with F8:
	nm <F8> :call ToggleProse()<CR>

" Goyo plugin makes text more readable when writing prose:
	map <F10> :Goyo<CR>
	map <leader>f :Goyo \| set linebreak<CR>
	inoremap <F10> <esc>:Goyo<CR>a

" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" LATEX
so ~/.config/nvim/shortcut/LaTeX.vim
" PHP/HTML
so ~/.config/nvim/shortcut/web.vim
"""C & C++
so ~/.config/nvim/shortcut/clike.vim

"MARKDOWN
so ~/.config/nvim/shortcut/markdown.vim

" JavaScript
	autocmd Filetype javascript setlocal sw=2 sts=2 expandtab
	autocmd Filetype vue setlocal sw=2 sts=2 expandtab
""".xml
	autocmd FileType xml inoremap ,e <item><Enter><title><++></title><Enter><guid<space>isPermaLink="false"><++></guid><Enter><pubDate><Esc>:put<Space>=strftime('%a, %d %b %Y %H:%M:%S %z')<Enter>kJA</pubDate><Enter><link><++></link><Enter><description><![CDATA[<++>]]></description><Enter></item><Esc>?<title><enter>cit
	autocmd FileType xml inoremap ,a <a href="<++>"><++></a><++><Esc>F"ci"

vmap <expr> ++ VMATH_YankAndAnalyse()
nmap ++ vip++

vnoremap K xkP`[V`]
vnoremap J xp`[V`]
vnoremap L >gv
vnoremap H <gv
"inoremap <C-H> <C-W>
map <enter><enter> yi[:e <c-r>"<cr>


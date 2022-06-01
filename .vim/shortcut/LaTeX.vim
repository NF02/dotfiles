" Compile
	autocmd FileType tex map \c <Esc>:w<Enter>:!compiler<space><c-r>%<Enter>a
	autocmd FileType tex map \v :!zathura $(echo % \| sed 's/tex$/pdf/') & disown<CR><CR>
" Word count:
	autocmd FileType tex,plaintex map <F3> :w !detex \| wc -w<CR>
	autocmd FileType tex,plaintex inoremap <F3> <Esc>:w !detex \| wc -w<CR>

" LATEX SYNTAX
	autocmd FileType tex,plaintex inoremap ,fr \begin{frame}<Enter>\frametitle{}<Enter><Enter><++><Enter><Enter>\end{frame}<Enter><Enter><++><Esc>6kf}i
	autocmd FileType tex,plaintex inoremap ,fi \begin{fitch}<Enter><Enter>\end{fitch}<Enter><Enter><++><Esc>3kA
	autocmd FileType tex,plaintex inoremap ,exe \begin{exe}<Enter>\ex<Space><Enter>\end{exe}<Enter><Enter><++><Esc>3kA
	autocmd FileType tex,plaintex inoremap ,em \emph{}<++><Esc>T{i
	autocmd FileType tex,plaintex inoremap ,bf \textbf{}<++><Esc>T{i
	autocmd FileType tex,plaintex vnoremap , <ESC>`<i\{<ESC>`>2la}<ESC>?\\{<Enter>a
	autocmd FileType tex,plaintex inoremap ,it \textit{}<++><Esc>T{i
	autocmd FileType tex,plaintex inoremap ,ct \textcite{}<++><Esc>T{i
	autocmd FileType tex,plaintex inoremap ,cp \parencite{}<++><Esc>T{i
	autocmd FileType tex,plaintex inoremap ,glos {\gll<Space><++><Space>\\<Enter><++><Space>\\<Enter>\trans{``<++>''}}<Esc>2k2bcw
	autocmd FileType tex,plaintex inoremap ,x \begin{xlist}<Enter>\ex<Space><Enter>\end{xlist}<Esc>kA<Space>
	autocmd FileType tex,plaintex inoremap ,ol \begin{enumerate}<Enter><Enter>\end{enumerate}<Enter><Enter><++><Esc>3kA\item<Space>
	autocmd FileType tex,plaintex inoremap ,ul \begin{itemize}<Enter><Enter>\end{itemize}<Enter><Enter><++><Esc>3kA\item<Space>
	autocmd FileType tex,plaintex inoremap ,li <Enter>\item<Space>
	autocmd FileType tex,plaintex inoremap ,ref \ref{}<Space><++><Esc>T{i
	autocmd FileType tex,plaintex inoremap ,tab \begin{tabular}<Enter><++><Enter>\end{tabular}<Enter><Enter><++><Esc>4kA{}<Esc>i
	autocmd FileType tex,plaintex inoremap ,ot \begin{tableau}<Enter>\inp{<++>}<Tab>\const{<++>}<Tab><++><Enter><++><Enter>\end{tableau}<Enter><Enter><++><Esc>5kA{}<Esc>i
	autocmd FileType tex,plaintex inoremap ,can \cand{}<Tab><++><Esc>T{i
	autocmd FileType tex,plaintex inoremap ,con \const{}<Tab><++><Esc>T{i
	autocmd FileType tex,plaintex inoremap ,v \vio{}<Tab><++><Esc>T{i
	autocmd FileType tex,plaintex inoremap ,a \href{}{<++>}<Space><++><Esc>2T{i
	autocmd FileType tex,plaintex inoremap ,sc \textsc{}<Space><++><Esc>T{i
	autocmd FileType tex,plaintex inoremap ,chap \chapter{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex,plaintex inoremap ,sec \section{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex,plaintex inoremap ,ssec \subsection{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex,plaintex inoremap ,sssec \subsubsection{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex,plaintex inoremap ,st <Esc>F{i*<Esc>f}i
	autocmd FileType tex,plaintex inoremap ,beg \begin{DELRN}<Enter><++><Enter>\end{DELRN}<Enter><Enter><++><Esc>4k0fR:MultipleCursorsFind<Space>DELRN<Enter>c
	autocmd FileType tex,plaintex inoremap ,up <Esc>/usepackage<Enter>o\usepackage{}<Esc>i
	autocmd FileType tex,plaintex nnoremap ,up /usepackage<Enter>o\usepackage{}<Esc>i
	autocmd FileType tex,plaintex inoremap ,tt \texttt{}<Space><++><Esc>T{i
	autocmd FileType tex,plaintex inoremap ,bt {\blindtext}
	autocmd FileType tex,plaintex inoremap ,nu $\varnothing$
	autocmd FileType tex,plaintex inoremap ,col \begin{columns}[T]<Enter>\begin{column}{.5\textwidth}<Enter><Enter>\end{column}<Enter>\begin{column}{.5\textwidth}<Enter><++><Enter>\end{column}<Enter>\end{columns}<Esc>5kA
	autocmd FileType tex,plaintex inoremap ,rn (\ref{})<++><Esc>F}i
	autocmd FileType tex,plaintex inoremap ,cr \begin{center}<Enter><++><Enter>\end{center}<Enter><Enter><++><Esc>4kA<Esc>i
	autocmd FileType tex,plaintex inoremap ,eq \begin{equation}<Enter><Enter>\end{equation}<Enter><Enter><++><Esc>4kA<Esc>i<tab>
	autocmd FileType tex,plaintex inoremap ,eq* \begin{equation*}<Enter><Enter>\end{equation*}<Enter><Enter><++><Esc>4kA<Esc>i<tab>
	autocmd FileType tex,plaintex inoremap ,mcol \begin{multicols}{<++>}<Enter><Enter>\end{multicols}<Enter><Enter><++><Esc>4kA<Esc>i<tab>
	autocmd FileType tex,plaintex inoremap ,tks \begin{tasks}<Enter><Enter>\end{\tasks}<Enter><Enter><++><Esc>4kA<Esc>i<tab>\task
	autocmd FileType tex,plaintex inoremap ,tk  <Enter>\task 
	autocmd FileType tex,plaintex inoremap ,far \frac{<++>}{<++>}




""".bib
	autocmd FileType bib inoremap ,a @article{<Enter><tab>author<Space>=<Space>"<++>",<Enter><tab>year<Space>=<Space>"<++>",<Enter><tab>title<Space>=<Space>"<++>",<Enter><tab>journal<Space>=<Space>"<++>",<Enter><tab>volume<Space>=<Space>"<++>",<Enter><tab>pages<Space>=<Space>"<++>",<Enter><tab>}<Enter><++><Esc>8kA,<Esc>i
	autocmd FileType bib inoremap ,b @book{<Enter><tab>author<Space>=<Space>"<++>",<Enter><tab>year<Space>=<Space>"<++>",<Enter><tab>title<Space>=<Space>"<++>",<Enter><tab>publisher<Space>=<Space>"<++>",<Enter><tab>}<Enter><++><Esc>6kA,<Esc>i
	autocmd FileType bib inoremap ,c @incollection{<Enter><tab>author<Space>=<Space>"<++>",<Enter><tab>title<Space>=<Space>"<++>",<Enter><tab>booktitle<Space>=<Space>"<++>",<Enter><tab>editor<Space>=<Space>"<++>",<Enter><tab>year<Space>=<Space>"<++>",<Enter><tab>publisher<Space>=<Space>"<++>",<Enter><tab>}<Enter><++><Esc>8kA,<Esc>i

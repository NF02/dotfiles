" PHP/HTML
	let html_use_css = 1
	autocmd FileType php,html inoremap ,b <b></b><Space><++><Esc>FbT>i
	autocmd FileType php,html inoremap ,it <em></em><Space><++><Esc>FeT>i
	autocmd FileType php,html inoremap ,1 <h1></h1><Enter><Enter><++><Esc>2kf<i
	autocmd FileType php,html inoremap ,2 <h2></h2><Enter><Enter><++><Esc>2kf<i
	autocmd FileType php,html inoremap ,3 <h3></h3><Enter><Enter><++><Esc>2kf<i
	autocmd FileType php,html inoremap ,p <p></p><Enter><Enter><++><Esc>02kf>a
	autocmd FileType php,html inoremap ,a <a<Space>href=""><++></a><Space><++><Esc>14hi
	autocmd FileType php,html inoremap ,e <a<Space>target="_blank"<Space>href=""><++></a><Space><++><Esc>14hi
	autocmd FileType php,html inoremap ,ul <ul><Enter><li></li><Enter></ul><Enter><Enter><++><Esc>03kf<i
	autocmd FileType php,html inoremap ,li <Esc>o<li></li><Esc>F>a
	autocmd FileType php,html inoremap ,ol <ol><Enter><li></li><Enter></ol><Enter><Enter><++><Esc>03kf<i
	autocmd FileType php,html inoremap ,im <img src="" alt="<++>"><++><esc>Fcf"a
	autocmd FileType php,html inoremap ,td <td></td><++><Esc>Fdcit
	autocmd FileType php,html inoremap ,tr <tr></tr><Enter><++><Esc>kf<i
	autocmd FileType php,html inoremap ,th <th></th><++><Esc>Fhcit
	autocmd FileType php,html inoremap ,tab <table><Enter></table><Esc>O
	autocmd FileType php,html inoremap ,gr <font color="green"></font><Esc>F>a
	autocmd FileType php,html inoremap ,rd <font color="red"></font><Esc>F>a
	autocmd FileType php,html inoremap ,yl <font color="yellow"></font><Esc>F>a
	autocmd FileType php,html inoremap ,dt <dt></dt><Enter><dd><++></dd><Enter><++><esc>2kcit
	autocmd FileType php,html inoremap ,dl <dl><Enter><Enter></dl><enter><enter><++><esc>3kcc
	autocmd FileType php,html inoremap &<space> &amp;<space>
	" bootstrap
	" alerts
	autocmd FileType php,html inoremap ,su <div class="alert alert-success"><++></div><++><Esc>Fdcit
	autocmd FileType php,html inoremap ,da <div class="alert alert-danger"><++></div><++><Esc>Fdcit
	autocmd FileType php,html inoremap ,wa <div class="alert alert-warnig"><++></div><++><Esc>Fdcit
	autocmd FileType php,html inoremap ,lt <div class="alert alert-light"><++></div><++><Esc>Fdcit
	autocmd FileType php,html inoremap ,da <div class="alert alert-dark"><++></div><++><Esc>Fdcit
	autocmd FileType php,html inoremap ,lk <div class="alert alert-link"><++></div><++><Esc>Fdcit
	

	" previw
	autocmd FileType php,html map \v :!qutebrowser $(echo % \| sed 's/html$/html/') & disown<CR><CR>

" netrw config
"let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
"let g:netrw_altv = 1
"let g:netrw_winsize = 25
let g:netrw_hide = 0
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

" UI & Interaction
set number
set wildmenu
set incsearch
set hls

" Editor
syntax enable
set tabstop=4
set cursorline
set colorcolumn=80
set autoindent
set scrolloff=5

" Color changes
hi MatchParen cterm=none ctermbg=darkgrey ctermfg=white

" Allow project specific vimrc files
set exrc

" Backup settings
set noswapfile

" Shortcuts
" CTRL+Space for autocompletion
imap <C-@> <C-n>
nmap <C-D> :w <bar> !make all<cr>
"nmap <C-C> :!bash<cr>
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map f :call ShowFuncName() <CR>
map <C-f> :silent exec AllFuncInNewTab()<CR>
nmap b :!git blame %<CR>
nmap <C-u> :call ShowUsages()<CR>
imap <C-u> <ESC>:call ShowUsages()<CR>
" Refactor rename
nnoremap gr :%s/\<<C-r><C-w>\>//gc<left><left><left>
" formatting
map <C-k> :w<CR>! clang-format --style=webkit -i %<CR>:e!<CR>
imap <C-k> <ESC> :w<CR>! clang-format --style=webkit -i %<CR>:e!<CR>I
" re-generate tags
map <C-g> :! bash -c "set -e xtrace; gcc -M % \| tr '\\\\ ' '\n' \| sed -e '/^$/d' -e '/\.o:[ \t]*$/d' \| ctags -L - --c++-kinds=+p --fields=+iaS --extras=+q"<CR><CR>

function! ShowUsages()
	let l:cword = expand('<cword>')
	let l:command='git grep --no-index -HIpnw '.l:cword

	tabnew
	execute "r !".l:command

	" Add new line before each function and print the function name above the
	" first result. This helps copying it to go to it.
	silent %s/.*\.[a-zA-Z0-9]*=\d*=\(.*\).*/\r\1\r&/

	set nomodified
	set syntax=c

	" Clear search results
	" let @/=""

	" highlight search string
	call search(l:cword)
	call matchadd("Search", l:cword)
endfun

nnoremap <C-S-PageUp> :tabprevious<CR>
nnoremap <C-S-PageDown>   :tabnext<CR>

" Show all functions in C-file
function! AllFuncInNewTab()
	redir @a
	g/^[a-zA-Z0-9\-_]*([a-zA-Z0-9\-_]* [a-zA-Z0-9\-_]*
	redir END
	tabnew
	put! a
	" %s/^ \?[0-9]* //g
	" %s/([a-zA-Z0-9_ \*,]*)\?//g
	set nomodified
endfunction

" Get function name
fun! ShowFuncName()
	echohl ModeMsg
	echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bWn'))
	echohl None
endfun

" Disable unsafe commads
set secure

" Comment line shortcut
nmap <silent> <C-C> :call CommentLine()<CR>
nmap <silent> <C-X> :call UnCommentLine()<CR>
imap <silent> <C-C> <ESC>:call CommentLine()<CR>a
imap <silent> <C-X> <ESC>:call UnCommentLine()<CR>a

" Puts the commentString at the start of the line
function! Comment(commentString)
	execute ":silent! normal ^i" . a:commentString . "\<ESC>\<down>^"
endfun

" Removes the commentString from the start of the line
function! UnComment(commentString)
	execute ":silent! normal :nohlsearch\<CR>:s/" . a:commentString . "//\<CR>:nohlsearch\<CR>\<down>^"
endfun

" function to comment line in normal mode
function! CommentLine()
	if IsCLike()
		call Comment("//")
	elseif IsBashLike()
		call Comment("\#")
	endif
endfun

" function to un-comment line in normal mode
function! UnCommentLine()
	if IsCLike()
		call UnComment("\\/\\/")
	elseif IsBashLike()
		call UnComment("#")
	endif
endfun

" Comments with //
function! IsCLike()
	let file_name = buffer_name("%")

	" for c++, c, java, php, go, js, ts
	return file_name =~ '\.cpp$' || file_name =~ '\.hpp$' || file_name =~ '\.java$' || file_name =~ '\.php[2345]\?$' || file_name =~ '\.c$' || file_name =~ '\.C$' || file_name =~ '\.go$' || file_name =~ '\.js$' || file_name =~ '\.ts$'
endfun

" Comments with #
function! IsBashLike()
	let file_name = buffer_name("%")

	" for bash, shell, python, sql, perl, r
	return file_name =~ '\.sh$' || file_name =~ '\.bash$' || file_name =~ '\.py$' || file_name =~ '\.sql$' || file_name =~ '\.perl$' || file_name =~ '\.r$'
endfun

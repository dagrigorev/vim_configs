if v:progname =~? "evim"
	finish
endif

if exists('skip_defaults_vim')
	finish
endif

filetype indent plugin on

if &compatible
	set nocompatible
endif

silent! while 0
	set nocompatible
silent! endwhile

set langmenu=en_US
let $LANG = 'en_US'

set nu!
set ai!

colo ron
syntax on
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start

set history=200
set ruler
set showcmd
set wildmenu

set ttimeout
set ttimeoutlen=100

set display=truncate

set scrolloff=5

if has('reltime')
	set incsearch
endif

"set nformats-=octal

if has('win32')
	set guioptions-=t
endif

map Q gq

inoremap <C-U> <C-G>u<C-U>

if has('mouse')
	if &term =~ 'xterm'
		set mouse=a
	else
		set mouse=nvi
	endif
endif

if $t_Co > 2 || has("gui_running")
	let c_comment_strings=1
endif

if 1
	augroup vimStartup
		au!

		autocmd BufReadPost *
			\ if line("\'") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
			\ | exe "normal! g`\""
			\ | endif
	augroup END
endif

if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		\ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
	set nolangremap
endif

if has('win32') || has('win64')
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after
endif

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview' if you
" don't want to see any documentation whatsoever.
set completeopt=longest,menuone,preview
" Set desired preview window height for viewing documentation.
" You might also want to look at the echodoc plugin.
set previewheight=5

execute pathogen#infect()

let g:OmniSharp_server_path = 'C:\tools\OmniSharp\OmniSharp.exe'
" Use the stdio version of OmniSharp-roslyn:
let g:OmniSharp_server_stdio = 1
" Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 5

let g:OmniSharp_selector_ui = ''
let g:OmniSharp_highlight_types = 3

let g:OmniSharp_highlight_groups = {
\ 'csUserIdentifier': [
\   'constant name', 'enum member name', 'field name', 'identifier',
\   'local name', 'parameter name', 'property name', 'static symbol'],
\ 'csUserInterface': ['interface name'],
\ 'csUserMethod': ['extension method name', 'method name'],
\ 'csUserType': ['class name', 'enum name', 'namespace name', 'struct name']
\}

let g:OmniSharp_highlight_groups = {
\ 'Title': ['enum name', 'namespace name']
\}

augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

    " Find all code errors/warnings for the current solution and populate the quickfix window
    autocmd FileType cs nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
augroup END

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <Leader>nm :OmniSharpRename<CR>
nnoremap <F2> :OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <Leader>ss :OmniSharpStartServer<CR>
nnoremap <Leader>sp :OmniSharpStopServer<CR>

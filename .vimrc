"execute pathogen#infect()
"Settings
set relativenumber
set nu
set hlsearch
let python_highlight_all=1
syntax on
set encoding=utf-8


"Themes
let base16colorspace=256  " Access colors present in 256 colorspace
let g:spacegray_italicize_comments = 1
colorscheme spacegray
"colorscheme SpacegrayEighties


"Keybinds
set tabstop=8 expandtab shiftwidth=4 softtabstop=4
nnoremap <C-@> i
inoremap <C-@> <Esc>


"Plugins with vim-plug
call plug#begin('~/.vim/plugged')

"Fixes Python indentation of vim
Plug 'vim-scripts/indentpython.vim'
"Better autocomplete engine
Plug 'Valloric/YouCompleteMe'
let g:ycm_autoclose_preview_window_after_completion=1
map <C-g> :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'

"PEP 8 checking
Plug 'nvie/vim-flake8'

"Checks syntax on save
Plug 'vim-syntastic/syntastic'

"Tree sidebar
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
let NERDTreeTabsIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
let g:nerdtree_tabs_open_on_console_startup = 1
"au VimEnter * :NERDTreeTabsToggle
"au VimEnter * wincmd p "auto select main panel

"Close NERDTree if it is the last open buffer
au WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

"Super search
Plug 'ctrlpvim/ctrlp.vim'

call plug#end() 
"filetype plugin on
"set omnifunc=syntaxcomplete#Complete

set nocompatible
"let g:tagbar_autofocus = 1

"PEP 8 tabbing and spacing
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

"let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

"""""""""""""""""""""""""""""""""""""
" Mappings configurationn
"""""""""""""""""""""""""""""""""""""
" map <C-m> :TagbarToggle<CR>

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Mapping selecting Mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

set foldmethod=indent

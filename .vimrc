""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Huge thanks to "Amir Salihefendic" : https://github.com/amix
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" It will be prepended with https://github.com/amix/vimrc/tree/master/vimrcs (basic.vim extended.vim)


""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>


""""""""""""""""""""""""""""""
" => MRU plugin
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400
map <leader>f :MRU<CR>


""""""""""""""""""""""""""""""
" => YankRing
""""""""""""""""""""""""""""""
let g:yankring_history_dir = '/home/developer/.vim_runtime/temp_dirs'


""""""""""""""""""""""""""""""
" => CTRL-P
""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 'rw'

let g:ctrlp_map = '<c-f>'
map <leader>j :CtrlP<cr>
map <c-b> :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'
let g:ctrlp_root_markers = ['.git']


""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH


" The Silver Searcher
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "right"
let g:NERDTreeWinSize=50
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark 
map <leader>nf :NERDTreeFind<cr>
let NERDTreeShowHidden=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree Tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => TagBar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <F8> :TagbarToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-go
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>e <Plug>(go-rename)

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-multiple-cursors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:multi_cursor_next_key="\<C-s>"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext http://amix.dk/blog/post/19678
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim-Airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
" Always show statusline
set laststatus=2


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => buffer switch
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Leader>. :bn<CR>
nnoremap <Leader>, :bp<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => color and theme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
colorscheme solarized
set relativenumber
set number

""""""""""""""""""""""""""""""
" => rainbow_parentheses
""""""""""""""""""""""""""""""
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{','}']]
" Activation based on file type
augroup rainbow_lisp
  autocmd!
  autocmd FileType c,cpp,lisp,clojure,scheme,java RainbowParentheses
augroup END
" List of colors that you do not want. ANSI code or #RRGGBB
let g:rainbow#blacklist = [233, 234]


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Set file types
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.drl setfiletype drools

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Snippets
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => undotree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <F5> :UndotreeToggle<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => YCM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <F9> :YcmCompleter FixIt<cr>
nnoremap <F10> :YcmForceCompileAndDiagnostics<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Set Vim working directory to the current location
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autochdir


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Set Tabular
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=','
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Indent Guides
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 0
let g:indent_guides_start_level = 2
let g:indent_guides_color_change_percent=3
nmap <F6> :IndentGuidesToggle<CR>
set ts=2 sw=2 et


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => 256 colors terminal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => UTF-8
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8 


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => tagbar TypeScript
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
\ }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => grammarous
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:grammarous#default_comments_only_filetypes={'*' : 1, 'help' : 0, 'markdown' : 0,}
let g:grammarous#use_vim_spelllang=1
nmap <leader>gc :% GrammarousCheck --no-preview<cr>
nmap <leader>gr :GrammarousReset<cr>
nmap <leader>gn <Plug>(grammarous-move-to-next-error)
nmap <leader>gp <Plug>(grammarous-move-to-previous-error)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_check_on_open = 1

let g:syntastic_java_checkstyle_classpath = '/usr/share/java/checkstyle-all.jar'
let g:syntastic_java_checkstyle_conf_file = '/usr/share/java/resources/checkstyle/google_checks.xml'
let g:syntastic_java_checkers = ["checkstyle"]

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_async = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint','jshint']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gitgutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_sign_column_always = 1
let g:gitgutter_eager=1
let g:gitgutter_realtime=1
let g:gitgutter_sign_added = "\xe2\x8a\x9e"
let g:gitgutter_sign_modified = "\xe2\x8a\xa1"
let g:gitgutter_sign_removed = "\xe2\x8a\x9f"
let g:gitgutter_sign_modified_removed = "\xe2\x8a\xa0"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => incsearch
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:config_fuzzyall(...) abort
  return extend(copy({
  \   'converters': [
  \     incsearch#config#fuzzy#converter(),
  \     incsearch#config#fuzzyspell#converter()
  \   ],
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> / incsearch#go(<SID>config_fuzzyall())
noremap <silent><expr> ? incsearch#go(<SID>config_fuzzyall({'command': '?'}))
noremap <silent><expr> g? incsearch#go(<SID>config_fuzzyall({'is_stay': 1}))

" :h g:incsearch#auto_nohlsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set spell
set spellcamelcase
set tabstop=4
set shiftwidth=4
set guifont=Hack\ 9
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=DarkRed guibg=#600000
highlight ExtraWhitespace ctermbg=DarkRed guibg=#600000
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/



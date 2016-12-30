" You must have vim-plug installed
" Call :PlugInstall on first invocation, later on :PlugUpdate

call plug#begin()
" Colorscheme
Plug 'fatih/molokai'

" TOOLS
"
" Make asynchronous
Plug 'neomake/neomake'

" AutoCompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" StatusBar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" TagBar
Plug 'majutsushi/tagbar'

" Use Tab to accept completion
Plug 'ervandew/supertab'

" Tmux naviation
Plug 'christoomey/vim-tmux-navigator'

" Sane tmux clipboard
Plug 'roxma/vim-tmux-clipboard'

" Toggle comments
Plug 'tpope/vim-commentary'

" Surround selections
Plug 'tpope/vim-surround'

" Enable more repeasts via dot '.'
Plug 'tpope/vim-repeat'

" Fast file searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Full Text search
Plug 'rking/ag.vim'

" Git support
Plug 'tpope/vim-fugitive'

" Automatic insertion of closing braces
Plug 'Raimondi/delimitMate'

" LANGUAGES
" Go support
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
" Go support autocompletion
Plug 'zchee/deoplete-go', { 'do': 'make'}

" Elm support
Plug 'elmcast/elm-vim', { 'for': 'elm'}

" JavaScript support
Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'zeekay/vim-beautify'

" JSON support
Plug 'elzr/vim-json', { 'for': 'json' }

" Plist support
Plug 'darfink/vim-plist', { 'for': 'plist' }

call plug#end()


"""""""""""""""""""""""""""""""""
" GENERAL VIM configuration
filetype plugin indent on 
let mapleader = ","
set mouse=a
set synmaxcol=800           " don't try to highlight long lines
set number      " show line numbers
set cursorline  " highlight the line of the cursor
set scrolloff=3 " have some context around the current line always on screen
set cmdheight=2
set pastetoggle=<F2> "Disable auto-indentation in paste mode
set hidden " Allow backgrounding buffers without writing them, and remember marks/undo for backgrounded buffers
set autoread " Auto-reload buffers when file changed on disk
set splitright
set splitbelow

set spelllang=de,en
hi clear SpellBad
hi SpellBad cterm=underline,bold ctermfg=red

" Disable swap files; systems don't crash that often these days
set updatecount=0
set nobackup
set noswapfile
set undofile
set undodir=~/.nvim/undodir
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

"" Whitespace
set listchars=tab:▸\ ,trail:•,extends:❯,precedes:❮
set list
set expandtab
set tabstop=2


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch                      " highlight matches
set ignorecase                    " searches are case insensitive...
set smartcase                     " ... unless they contain at least one capital letter
set gdefault                      " have :s///g flag by default on

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>


" ignore Rubinius, Sass cache files
set wildignore+=tmp/**,*.rbc,.rbx,*.scssc,*.sassc,*.so,*.swp,*.zip,*.exe
set wildignore+=*.class,.git,.hg,.svn,target/**
" ignore Bundler standalone/vendor installs & gems
set wildignore+=bundle/**,vendor/bundle/**,vendor/cache/**,vendor/gems/**,vendor/**
set wildignore+=node_modules/**
set wildignore+=.bundle/**
set wildmode=longest,list,full
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TMUX
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  if !has('nvim')
    set ttymouse=xterm2
endif
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FileType Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=80
endfunction


augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!

  autocmd BufEnter * if &filetype == "" | setlocal ft=text | endif

  " Avoid showing trailing whitespace when in insert mode
  au InsertEnter * :set listchars-=trail:•
  au InsertLeave * :set listchars+=trail:•


  " Elm
  " autocmd BufWritePost *.elm silent execute "!elm-format --yes %" | edit! | set filetype=elm

  " Some file types use real tabs
  au FileType {make,gitconfig} set noexpandtab

  " Fish shell support
  autocmd FileType fish compiler fish

  " Make sure all markdown files have the correct filetype set and setup wrapping
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} setf markdown | call s:setupWrapping()

  " https://github.com/sstephenson/bats
  au BufNewFile,BufRead *.bats setf sh
  "
  " Enable geojson filetype
  au BufNewFile,BufRead *.geojson setf json

  " Enable gradle fileType support as groovy files.
  au BufNewFile,BufRead *.gradle setf groovy
  au BufNewFile,BufRead *.groovy setf groovy

  au! BufNewFile,BufRead *.ly,*.ily,*.lytex set ft=lilypond commentstring=%\ %s

  " Enable gnuplot fileType
  au BufNewFile,BufRead *.gnuplot setf gnuplot

  " make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
  au FileType python set softtabstop=4 tabstop=4 shiftwidth=4
  au FileType sh set softtabstop=2 tabstop=2 shiftwidth=2
  au FileType go set softtabstop=2 tabstop=2 shiftwidth=2

  autocmd FileType puppet set commentstring=#\ %s

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif

  " mark Jekyll YAML frontmatter as comment
  au BufNewFile,BufRead *.{md,markdown,html,xml} sy match Comment /\%^---\_.\{-}---$/

  " magic markers: enable using `H/S/J/C to jump back to
  " last HTML, stylesheet, JS or Ruby code buffer
  au BufLeave *.{erb,html}      exe "normal! mH"
  au BufLeave *.{css,scss,sass} exe "normal! mS"
  au BufLeave *.{js,coffee}     exe "normal! mJ"
  au BufLeave *.{rb}            exe "normal! mC"
augroup END
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General ShortCuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" don't use Ex mode, use Q for formatting
map Q gq
" :nnoremap <CR> :nohlsearch<cr> " clear the search buffer when hitting return
:nnoremap <Space> za " toggle the current fold

" disable cursor keys in normal mode
map <Left>  :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up>    :echo "no!"<cr>
map <Down>  :echo "no!"<cr>

" In command-line mode, C-a jumps to beginning (to match C-e)
cnoremap <C-a> <Home>

" <Tab> indents if at the beginning of a line; otherwise does completion
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>


" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" StatusLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" http://vimcasts.org/e/14 expand %% to current directory in command-line mode
cnoremap %% <C-R>=expand('%:h').'/'<cr>
if has("statusline") && !&cp
  set laststatus=2                   " always show the status bar
  set statusline=%<%1*\ %f\ %*       " filename
  set statusline+=%2*%m%r%*          " modified, readonly
  set statusline+=\ %3*%y%*          " filetype
  set statusline+=%=                 " left-right separation point
  set statusline+=\ %5*%l%*/%L[%p%%] " current line/total lines
  set statusline+=\ %5*%v%*[0x%B]    " current column [hex char]
endif

hi StatusLine term=inverse,bold cterm=NONE ctermbg=24 ctermfg=189
hi StatusLineNC term=inverse,bold cterm=NONE ctermbg=24 ctermfg=153
hi User1 term=inverse,bold cterm=NONE ctermbg=29 ctermfg=159
hi User2 term=inverse,bold cterm=NONE ctermbg=29 ctermfg=16
hi User3 term=inverse,bold cterm=NONE ctermbg=24
hi User4 term=inverse,bold cterm=NONE ctermbg=24 ctermfg=221
hi User5 term=inverse,bold cterm=NONE ctermbg=24 ctermfg=209

" populate arglist with files from the quickfix list
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set statusline=%{getcwd()}/%f\ %{fugitive#head()}\ %m\ %=\ [%l,%c]\ [%L,%p%%]
" set statusline=%#ErrorMsg#%{neomake#statusline#QflistStatus('qf:\ ')}
" set statusline+=%#warningmsg#
" set statusline+=%
let g:neomake_place_signs=0
let g:neomake_verbose=0
let g:neomake_echo_current_error=1
let g:neomake_open_list=1

" Neomake on ctrl-c
" use global neomake on project (with !)
" Neomake! uses the quickfix window
nnoremap <c-c> :Neomake!<cr>

" Close quickfix window, if it is the last window
au BufEnter * call MyLastWindow()
function! MyLastWindow()
  " if the window is quickfix go on
  if &buftype=="quickfix"
    " if this window is last on screen quit without warning
    if winbufnr(2) == -1
      quit!
    endif
  endif
endfunction

let g:go_list_type = "quickfix"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clipboard
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" custom clipboard for mac os x
" map <C-c> y:e ~/tmpclipboard<CR>P:w !pbcopy<CR><CR>:bdelete!<CR>
set clipboard=unnamed
" vmap <C-x> :!pbcopy<CR>  
" vmap <C-c> :w !pbcopy<CR><CR> 

" toggle between last open buffers
nnoremap <leader><leader> <c-^>

" reselect text, which was just inserted.
nnoremap <leader>v V`]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle quick fix
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <script> <silent> <leader>e :call ToggleLocationList()<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add modeline shortcut
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Formatting text
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" remove trailing whitespace
command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>

" reindent
map <F3> mzgg=G`z<CR>

" reformat
map <F4> mzggVGgq`z<CR>


" JSON
let g:vim_json_syntax_conceal = 0
command! JsonPretty %!jq '.'
command! JsonMini %!jq --compact-output '.'
au FileType json nmap <leader><C-p> :JsonPretty<cr>
au FileType json nmap <leader><C-m> :JsonMini<cr>
autocmd FileType json noremap <buffer>  <F3> :JsonPretty<cr>

" XML
command! XmlPretty exe ":silent %!xmllint --format --recover - 2>/dev/null"
command! XmlMini exe ":silent %!xmllint --noblanks - 2>/dev/null"
au FileType xml nmap <leader><C-p> :XmlPretty<cr>
au FileType xml nmap <leader><C-m> :XmlMini<cr>
au FileType xml nmap <F3> :XmlPretty<cr>

" html,css,javascript
" p
"
autocmd FileType javascript noremap <buffer>  <F3> :Beautify<cr>
autocmd FileType html noremap <buffer> <F3> :Beautify<cr>
autocmd FileType css noremap <buffer> <F3> :Beautify<cr>


" Web (html,css,javascript)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:javascript_enable_domhtmlcss = 1
let g:used_javascript_libs = 'angularjs,angularui,underscore'
let g:tern_show_argument_hints = 'on_move'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UltiSnips
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Integrates UltiSnips tab completion with YouCompleteMe
" See: https://github.com/Valloric/YouCompleteMe/issues/36
let g:UltiSnipsSnippetDirectories  = ["snips", "UltiSnips", "UltiSnip"]
function! g:UltiSnips_Complete()
  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res == 0
    if pumvisible()
      return "\<C-n>"
    else
      call UltiSnips#JumpForwards()
      if g:ulti_jump_forwards_res == 0
        return "\<TAB>"
      endif
    endif
  endif
  return ""
endfunction

function! g:UltiSnips_Reverse()
  call UltiSnips#JumpBackwards()
  if g:ulti_jump_backwards_res == 0
    return "\<C-P>"
  endif

  return ""
endfunction


if !exists("g:UltiSnipsJumpForwardTrigger")
  let g:UltiSnipsJumpForwardTrigger = "<tab>"
endif

if !exists("g:UltiSnipsJumpBackwardTrigger")
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
endif

au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger     . " <C-R>=g:UltiSnips_Complete()<cr>"
au InsertEnter * exec "inoremap <silent> " .     g:UltiSnipsJumpBackwardTrigger . " <C-R>=g:UltiSnips_Reverse()<cr>"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GOLANG
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:go_def_mapping_enabled = 0
au FileType go nmap <C-]> <Plug>(go-def)
au FileType go nmap <Leader><C-]> <Plug>(go-doc-vertical)

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>e <Plug>(go-rename)
au FileType go nmap <Leader>gc <Plug>(go-channelpeers)

au FileType go nmap <leader>gv <Plug>(go-vet)
au FileType go nmap <Leader>gl <Plug>(go-metalinter)
au FileType go nnoremap <leader>ge :call go#errcheck#Run()<CR>
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 0
let g:go_auto_type_info = 1
let g:go_highlight_structs = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_term_enabled = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Elm
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType elm nmap <leader>R <Plug>(elm-make)
au FileType elm nmap <leader>B <Plug>(elm-make)
au FileType elm nmap <leader>T <Plug>(elm-test)
au FileType elm nmap <Leader><C-]> <Plug>(elm-show-docs)
au FileType elm nmap <Leader>d <Plug>(elm-show-docs)
au FileType elm nmap <Leader>gd <Plug>(elm-browse-docs)
au FileType elm noremap <buffer> <F3> <Plug>(elm-format)

let g:elm_jump_to_error = 1
let g:elm_make_output_file = "elm.js"
let g:elm_make_show_warnings = 1
let g:elm_browser_command = ""
let g:elm_detailed_complete = 1
let g:elm_format_autosave = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AG
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable('ag')
   set grepprg=ag\ --vimgrep\ --nogroup\ --nocolor
   " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
   let g:ctrlp_user_command = 'ag %s -l --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "vendor/**"
      \ --ignore "**/*.pyc"
      \ -g ""'
   let g:ctrlp_use_caching = 0
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EasyMotion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EasyMotion_use_smartsign_us = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EasyAlign
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap <leader>ea <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap <leader>ea <Plug>(EasyAlign)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ShortCuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader><leader>g :Ag<space>
nnoremap <leader>c <Plug>Kwbd


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader>b :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
" - window (nvim only)
let g:fzf_layout = { 'down': '~40%' }

" Advanced customization using autoload functions
autocmd VimEnter * command! Colors
  \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 40%,0'})

nnoremap <silent> <c-p> :FZF<CR>

function! s:align_lists(lists)
  let maxes = {}
  for list in a:lists
    let i = 0
    while i < len(list)
      let maxes[i] = max([get(maxes, i, 0), len(list[i])])
      let i += 1
    endwhile
  endfor
  for list in a:lists
    call map(list, "printf('%-'.maxes[v:key].'s', v:val)")
  endfor
  return a:lists
endfunction

function! s:btags_source()
  let lines = map(split(system(printf(
    \ 'ctags -f - --sort=no --excmd=number --language-force=%s %s',
    \ &filetype, expand('%:S'))), "\n"), 'split(v:val, "\t")')
  if v:shell_error
    throw 'failed to extract tags'
  endif
  return map(s:align_lists(lines), 'join(v:val, "\t")')
endfunction

function! s:btags_sink(line)
  execute split(a:line, "\t")[2]
endfunction

function! s:btags()
  try
    call fzf#run({
    \ 'source':  s:btags_source(),
    \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
    \ 'down':    '40%',
    \ 'sink':    function('s:btags_sink')})
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

" jump to TAGS in current buffer https://github.com/junegunn/fzf/wiki/Examples-(vim)
command! BTags call s:btags()


function! s:tags_sink(line)
  let parts = split(a:line, '\t\zs')
  let excmd = matchstr(parts[2:], '^.*\ze;"\t')
  execute 'silent e' parts[1][:-2]
  let [magic, &magic] = [&magic, 0]
  execute excmd
  let &magic = magic
endfunction

function! s:tags()
  if empty(tagfiles())
    echohl WarningMsg
    echom 'Preparing tags'
    echohl None
    call system('ctags -R')
  endif

  call fzf#run({
  \ 'source':  'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')).
  \            '| grep -v -a ^!',
  \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
  \ 'down':    '40%',
  \ 'sink':    function('s:tags_sink')})
endfunction

" Jump to tags across buffers https://github.com/junegunn/fzf/wiki/Examples-(vim)
command! Tags call s:tags()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
"
" " Show just the filename
" let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TagBar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tagbar_autofocus=1
let g:tagbar_autoshowtag=1
let g:tagbar_autopreview=0
let g:tagbar_width = 40

nnoremap <silent> <F9> :TagbarToggle<cr>
nnoremap <silent> <F5> :!ctags -R --exclude=.git --exclude=node_modules<cr><cr>

let g:tagbar_type_groovy = {
 \ 'ctagstype' : 'groovy',
 \ 'kinds' : [
     \ 'p:package',
     \ 'c:class',
     \ 'i:interface',
     \ 'f:function',
     \ 'v:variables',
     \ ]
 \ }


let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '~/.vim/extra/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

let g:tagbar_type_puppet = {
    \ 'ctagstype': 'puppet',
    \ 'kinds': [
        \'c:class',
        \'s:site',
        \'n:node',
        \'d:definition'
      \]
    \}

let g:tagbar_type_elm = {
    \ 'ctagstype': 'elm',
    \ 'kinds': [
        \'m:module',
        \'t:type',
        \'v:function'
      \]
    \}

let g:tagbar_type_snippets = {
    \ 'ctagstype' : 'snippets',
    \ 'kinds' : [
        \ 's:snippets',
    \ ]
\ }

" add a definition for Objective-C to tagbar
let g:tagbar_type_objc = {
    \ 'ctagstype' : 'ObjectiveC',
    \ 'kinds'     : [
        \ 'i:interface',
        \ 'I:implementation',
        \ 'p:Protocol',
        \ 'm:Object_method',
        \ 'c:Class_method',
        \ 'v:Global_variable',
        \ 'F:Object field',
        \ 'f:function',
        \ 'p:property',
        \ 't:type_alias',
        \ 's:type_structure',
        \ 'e:enumeration',
        \ 'M:preprocessor_macro',
    \ ],
    \ 'sro'        : ' ',
    \ 'kind2scope' : {
        \ 'i' : 'interface',
        \ 'I' : 'implementation',
        \ 'p' : 'Protocol',
        \ 's' : 'type_structure',
        \ 'e' : 'enumeration'
    \ },
    \ 'scope2kind' : {
        \ 'interface'      : 'i',
        \ 'implementation' : 'I',
        \ 'Protocol'       : 'p',
        \ 'type_structure' : 's',
        \ 'enumeration'    : 'e'
    \ }
\ }

let g:tagbar_type_asciidoc = {
    \ 'ctagstype' : 'asciidoc',
    \ 'kinds' : [
        \ 's:Table of Contents'
    \ ]
\ }
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



" omnifuncs

augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

" auto-save on build
set autowrite

" Plugin Configuration
"
" Colorscheme
let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai

"
" AutoCompletion
let g:deoplete#enable_at_startup = 1
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
" close suggest window after leaving insert mode
" autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

" UltiSnips config
inoremap <silent><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" JavaScript support
if exists('g:plugs["tern_for_vim"]')
  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1
  autocmd FileType javascript setlocal omnifunc=tern#Complete
endif

" SuperTab completion invert result list
let g:SuperTabDefaultCompletionType = "<c-n>"





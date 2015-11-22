""
"" Thanks:
""   Gary Bernhardt  <destroyallsoftware.com>
""   Drew Neil  <vimcasts.org>
""   Tim Pope  <tbaggery.com>
""   Janus  <github.com/carlhuda/janus>
""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shell=bash " set to POSIX compatible shell (see https://github.com/dag/vim-fish)
let g:is_bash=1 " default shell syntax
set nocompatible
set exrc                    " load vimrc from current directory

if has('nvim')
  runtime! python_setup.vim
endif

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.status == 'updated' || a:info.force
    !./install.sh
  endif
endfunction

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'Raimondi/delimitMate'
Plug 'majutsushi/tagbar'
Plug 'ntpeters/vim-better-whitespace'
Plug 'wincent/terminus'
Plug 'matze/vim-lilypond'
Plug 'wellle/tmux-complete.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'rking/ag.vim'

Plug 'bling/vim-airline'
Plug 'scrooloose/syntastic'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle','NERDTreeFind'] }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'elixir-lang/vim-elixir'
Plug 'davejlong/cf-utils.vim'
Plug 'ap/vim-css-color'
Plug 'kballard/vim-swift', { 'for': 'swift' }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'pangloss/vim-javascript' | Plug 'jelera/vim-javascript-syntax' | Plug 'maksimr/vim-jsbeautify' | Plug 'einars/js-beautify'
Plug 'uarun/vim-protobuf', { 'for': 'proto' }
Plug 'rodjek/vim-puppet', { 'for': 'puppet' }
Plug 'dag/vim-fish', { 'for': 'fish' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'darfink/vim-plist', { 'for': 'plist' }
" Plug 'ekalinin/Dockerfile.vim', { 'for': 'dockerfile' }
Plug 'docker/docker' , {'for': 'Dockerfile'}
call plug#end()

filetype plugin indent on
runtime macros/matchit.vim  " enables % to cycle through `if/else/endif`

if has('gui_running')
  set background=light
else
  set background=dark
endif
color vividchalk

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
set undodir=~/.vim/undodir
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

"" Whitespace
set listchars=tab:▸\ ,trail:•,extends:❯,precedes:❮
set list
set expandtab

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching
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
set wildignore+=bundle/**,vendor/bundle/**,vendor/cache/**,vendor/gems/**
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
  set textwidth=120
endfunction


augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!

  " Avoid showing trailing whitespace when in insert mode
  au InsertEnter * :set listchars-=trail:•
  au InsertLeave * :set listchars+=trail:•

  " Some file types use real tabs
  au FileType {make,gitconfig} set noexpandtab

  " Fish shell support
  autocmd FileType fish compiler fish

  " Make sure all markdown files have the correct filetype set and setup wrapping
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown | call s:setupWrapping()

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
  au FileType sh set softtabstop=4 tabstop=4 shiftwidth=4

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
" map <Left>  :echo "no!"<cr>
" map <Right> :echo "no!"<cr>
" map <Up>    :echo "no!"<cr>
" map <Down>  :echo "no!"<cr>

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
  set statusline+=\ %4*%{fugitive#head()}%0*
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


let mapleader=","
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
" Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
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
autocmd FileType javascript noremap <buffer>  <F3> :call JsBeautify()<cr>
autocmd FileType html noremap <buffer> <F3> :call HtmlBeautify()<cr>
autocmd FileType css noremap <buffer> <F3> :call CSSBeautify()<cr>


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
let g:UltiSnipsExpandTrigger       = "<C-l>"
let g:UltiSnipsJumpForwardTrigger  = "<C-l>"
let g:UltiSnipsJumpBackwardTrigger = "<C-h>"
let g:UltiSnipsSnippetDirectories  = ["snips", "UltiSnips", "UltiSnip"]
" function! g:UltiSnips_Complete()
"   call UltiSnips#ExpandSnippet()
"   if g:ulti_expand_res == 0
"     if pumvisible()
"       return "\<C-n>"
"     else
"       call UltiSnips#JumpForwards()
"       if g:ulti_jump_forwards_res == 0
"         return "\<TAB>"
"       endif
"     endif
"   endif
"   return ""
" endfunction

" " Enable, when the first time in insert mode.
" au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GOLANG
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:go_def_mapping_enabled = 0
au FileType go nmap <C-]> <Plug>(go-def)
au FileType go nmap <Leader><C-]> <Plug>(go-doc-vertical)

au FileType go nmap <leader>R <Plug>(go-run)
au FileType go nmap <leader>B <Plug>(go-build)

au FileType go nmap <Leader>gi <Plug>(go-info)
au FileType go nmap <Leader>gr <Plug>(go-rename)
au FileType go nmap <Leader>gc <Plug>(go-channelpeers)

au FileType go nmap <leader>gtt <Plug>(go-test)
au FileType go nmap <leader>gtc <Plug>(go-coverage)
au FileType go nmap <leader>gv <Plug>(go-vet)
au FileType go nmap <Leader>gl <Plug>(go-lint)
au FileType go nnoremap <leader>ge :call go#errcheck#Run()<CR>
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


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
      \ --ignore "**/*.pyc"
      \ -g ""'
   let g:ctrlp_use_caching = 1
endif
" nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" call unite#custom_source('file_rec/async,file_rec,file_mru,file,buffer,grep',
"       \ 'ignore_pattern', join([
"       \ '\.git/',
"       \ '\.gradle/',
"       \ '\.bundle/',
"       \ 'bin/',
"       \ 'out/',
"       \ 'build/',
"       \ '\.tmp/',
"       \ 'tmp/',
"       \ ], '\|'))


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EasyMotion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EasyMotion_use_smartsign_us = 1
" nmap / <Plug>(easymotion-sn)
" xmap / <Esc><Plug>(easymotion-sn)\v%V
" omap / <Plug>(easymotion-tn)
" nnoremap g/ /
"
" " These `n` & `N` mappings are options. You do not have to map `n` & `N` to
" EasyMotion.
" " Without these mappings, `n` & `N` works fine. (These mappings just provide
" " different highlight method and have some other features )
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)
" nmap <leader>s <Plug>(easymotion-s2)
" nmap <leader>t <Plug>(easymotion-t2)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EasyAlign
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ShortCuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader><leader>g :Ag<space>
nnoremap <F1> :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
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
let g:fzf_layout = { 'down': '~20%' }

" Advanced customization using autoload functions
autocmd VimEnter * command! Colors
  \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'})

nnoremap <silent> <c-p> :FZF<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NerdTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDSpaceDelims=1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" YouCompleteMe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EclimCompletionMethod = 'omnifunc'
let g:tmuxcomplete#trigger = 'omnifunc'

let fts = ['c', 'cpp', 'objc']
" if index(fts, &filetype) != -1
"   let g:ycm_extra_conf_vim_data = ['&filetype']
"   let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
" endif
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
nnoremap <silent> <F5> :!ctags<cr><cr>

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


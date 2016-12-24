
call plug#begin()
" Colorscheme
Plug 'fatih/molokai'

" TOOLS
" AutoCompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

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


call plug#end()


" VIM configuration
filetype plugin indent on 

let mapleader = ","

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





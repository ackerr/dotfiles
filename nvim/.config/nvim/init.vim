let mapleader = " "

" neovim
if has("nvim")
  source $HOME/.config/nvim/nvim.vim
endif

" download vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs 
              \https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set nocompatible
set autoindent
set backspace=2

" fix move slow
set nocursorcolumn
set nocursorline
syntax sync minlines=256
set synmaxcol=300
set re=1
set lazyredraw

set encoding=utf-8
set fileencoding=utf-8
set hlsearch
set ignorecase
set incsearch
set number
set relativenumber
set smartindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set clipboard=unnamed
set scrolloff=5

set noswapfile  " 不需要.swp文件

" fold
set foldenable
set foldmethod=indent
set foldlevel=99

inoremap jk <Esc>
nnoremap <leader>ev  :vsplit $MYVIMRC<cr>
nnoremap <leader>sv  :source $MYVIMRC<cr>
nnoremap <c-y> viwy

noremap <leader>ll :nohl<cr>

" register
vnoremap p "_dP

" buffer
noremap <leader>dd :bp\|bd #<cr>      " close current buffer
noremap <leader>bo :%bd\|e#\|bd#<cr>  " close other buffers, except current
nnoremap H :bp<cr>
nnoremap L :bn<cr>
nnoremap <leader>w :w<cr>
vnoremap <leader>w <esc>:w<cr>
nnoremap <leader>q :q<cr>

" resize window
noremap + :resize +4<cr>
noremap _ :resize -4<cr>
noremap = :vertical resize +4<cr>
noremap - :vertical resize -4<cr>

" move window
nnoremap <c-h> <c-w><c-h>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>

filetype off
call plug#begin('~/.config/nvim/plugins')

Plug 'rakr/vim-one'
Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" edit
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'itchyny/vim-cursorword'
Plug 'junegunn/vim-easy-align'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'brooth/far.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'mg979/vim-visual-multi'
Plug 'editorconfig/editorconfig-vim'
Plug 'Vimjas/vim-python-pep8-indent'

" move
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'do': './install --all'  }
Plug 'junegunn/fzf.vim'
if has("nvim")
    Plug 'rbgrouleff/bclose.vim'
endif
Plug 'francoiscabrol/ranger.vim'
Plug 'romainl/vim-cool'
Plug 'psliwka/vim-smoothie'

" programming
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'honza/vim-snippets'
Plug 'andrewstuart/vim-kubernetes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }
Plug 'antoinemadec/coc-fzf'
Plug 'vim-test/vim-test'

" terminal
Plug 'voldikss/vim-floaterm'
" Plug 'skywind3000/asyncrun.vim'
" Plug 'skywind3000/asyncrun.extra'

" startuptime
" Plug 'tweekmonster/startuptime.vim'
" Plug 'dstein64/vim-startuptime'

call plug#end()
filetype plugin indent on

" Startify
let g:startify_enable_special = 0
let g:startify_session_autoload = 1
let g:startify_session_delete_buffers = 1
let g:startify_session_dir = '~/.config/nvim/session'
let g:startify_lists = [
            \ { 'type': 'sessions',  'header': ['   Sessions'] },
            \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
            \ { 'type': 'files',     'header': ['   Files'] },
            \]

" fzf
let g:fzf_preview_window = [ 'down:60%', 'ctrl-/' ]
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.7} }

nnoremap <silent> <leader>fr :Rg<cr>
xnoremap <silent> <leader>fr y:Rg <c-r>"<cr>
nnoremap <silent> <leader>ff :Files<cr>
nnoremap <silent> <c-p> :Files<cr>
nnoremap <silent> <leader>fb :Buffers<cr>
nnoremap <silent> <leader>fgf :GFiles?<cr>
nnoremap <silent> <leader>fgb :Git blame --date=short<cr>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec, 'down:60%', 'ctrl-/'), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! -nargs=* -bang BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))


"coc-fzf
let g:coc_fzf_preview='down:60%'
let g:coc_fzf_preview_toggle_key = "ctrl-/"
let g:coc_fzf_opts=['--layout=reverse']

noremap <silent> <m-c> :<C-u>CocFzfList commands<CR>

" fzf-preview
let g:fzf_preview_floating_window_rate = 0.7
let g:fzf_preview_fzf_preview_window_option = 'right:70%'
let g:fzf_preview_defalut_fzf_options = { '--preview-window': ':70%' }

" colorscheme
set t_Co=256
set background=dark
let g:one_allow_italics = 1
silent! colorscheme one
set termguicolors
hi SignColumn guifg=fg guibg=bg
hi CursorColumn guibg='#384C38'
" hi Normal guibg=None ctermbg=None

" Gitgutter
hi GitAddStripe ctermfg=66 ctermbg=66 guifg='#384C38' guibg='#384C38'
hi GitChangeStripe ctermfg=60 ctermbg=60 guifg='#374752' guibg='#374752'
hi GitDeleteStripe ctermfg=0 ctermbg=0
hi! link GitGutterAdd GitAddStripe
hi! link GitGutterChange GitChangeStripe
hi! link GitGutterDelete GitDeleteStripe
let g:gitgutter_sign_removed = '▶'
let g:gitgutter_preview_win_floating = 1

" NerdTree
hi! link NERDTreeFlags NERDTreeDir
let g:NERDTreeIgnore=['\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__', '.git$', '.idea', '.vscode', '\.swp']
let NERDTreeChDirMode=3
let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeAutoDeleteBuffer=1
let g:nerdtree_tabs_focus_on_files=1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

nnoremap <leader>m :NERDTreeFind<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

let g:easy_align_delimiters = {
\ '>': { 'pattern': '>>\|=>\|>' },
\ '/': {
\     'pattern':         '//\+\|/\*\|\*/',
\     'delimiter_align': 'l',
\     'ignore_groups':   ['!Comment'] },
\ }

" Airline
set noshowmode
set laststatus=1

let g:airline_theme='violet'
let g:airline_powerline_fonts = 1 " https://github.com/powerline/fonts
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
let g:airline_highlighting_cache=1
let g:airline_extensions=["tabline", "coc", "branch"]

" Comment
nnoremap <leader>/ :Commentary<cr>
vnoremap <leader>/ :Commentary<cr>

" GUI config
if has('gui_running')
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
    set guioptions-=m
    set guioptions-=T
    set guioptions-=e
    if has("win32")
        " https://github.com/tonsky/FiraCode/issues/462
        set guifont=Fira\ Code:h12
        set lines=38
        set columns=150
    else
        set guifont=Fira\ Code:h14
        set macligatures
        set lines=60
        set columns=250
    endif
    set linespace=3
endif

" coc.nvim
" ===================
let g:coc_global_extensions = [
    \ "coc-pyright",
    \ "coc-clangd",
    \ "coc-go",
    \ "coc-tsserver",
    \ "coc-vimlsp",
    \ "coc-json",
    \ "coc-yaml",
    \ "coc-marketplace",
    \ "coc-diagnostic",
    \ "coc-floaterm",
    \ "coc-lists",
    \ "coc-explorer",
    \ "coc-snippets",
    \ "coc-highlight",
    \ "coc-translator",
    \ "coc-yank"]

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649

set nobackup
set nowritebackup

" " Better display for messages
set cmdheight=1

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=400

" don't give |ins-completion-menu| messages.
set shortmess+=c

set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `alt-j` and `alt-k` to navigate diagnostics
nmap <silent> <m-j> <Plug>(coc-diagnostic-next)
nmap <silent> <m-k> <Plug>(coc-diagnostic-prev)

" Remap keys for gotos
nmap gd <Plug>(coc-definition)
nmap gy <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent! call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>rf <Plug>(coc-refactor)
nmap gx <Plug>(coc-openlink)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
autocmd BufWritePre *.py :Format

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :silent call CocAction('runCommand', 'editor.action.organizeImport')

autocmd BufWritePre *.go :OR

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" If use <TAB> , <c-i> can't use  <TAB> == <c-i> ?
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ca  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>cf  <Plug>(coc-fix-current)

" coc-translator
nmap <m-t> <Plug>(coc-translator-p)
vmap <m-t> <Plug>(coc-translator-pv)

" coc-yank
nnoremap <silent> <leader>y  :<C-u>CocList -A --normal yank<cr>

" coc-explorer
nnoremap <leader>o :CocCommand explorer<cr>

" ranger.vim
let g:ranger_map_keys = 0
let g:NERDTreeHijackNetrw = 0
let g:ranger_replace_netrw = 1

command! Rangerr FloatermNew ranger
nnoremap <leader>ra :Rangerr<cr>

" floaterm
noremap <leader>ft :FloatermNew --wintype=normal --position=bottom --height=20<cr>
noremap <leader>fp :FloatermNew --wintype=normal --position=right --width=0.5 --name=ipy ipython<cr>
vnoremap <leader>fs :FloatermSend<cr>
tnoremap <m-]> <c-\><c-n>:FloatermNext<cr>
tnoremap <m-[> <c-\><c-n>:FloatermPrev<cr>
tnoremap <c-w><c-w> <c-\><c-n><c-w>w

command! Lazygit FloatermNew lazygit
nnoremap <leader>lg :Lazygit<cr>

let g:floaterm_keymap_toggle = "<m-=>"
let g:floaterm_keymap_kill = "<m-q>"
let g:floaterm_autoclose = 1
let g:floaterm_width=0.7
let g:floaterm_height=0.6

" splitjoin
nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>

" vim-test
nmap <silent> tn :TestNearest<CR>
nmap <silent> tf :TestFile<CR>
nmap <silent> ts :TestSuite<CR>
nmap <silent> tl :TestLast<CR>
nmap <silent> tg :TestVisit<CR>

let test#strategy = "floaterm"
let test#python#runner = 'pytest'
let test#go#runner = "gotest"


" vim-go
let g:go_gopls_enabled=0
let g:go_def_mapping_enabled = 0
let g:go_fmt_autosave = 0

let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_methods = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_extra_types = 1

augroup go
  autocmd!
  " Show by default 4 spaces for a tab
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
  " :GoFmt
  autocmd FileType go nnoremap gf :GoFmt<cr>
  " :GoRun
  autocmd FileType go nmap <leader>gr  <Plug>(go-run)
augroup END

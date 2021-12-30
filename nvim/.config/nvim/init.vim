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
set signcolumn=yes

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
" set relativenumber
set smartindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set clipboard=unnamed
set scrolloff=5

set fillchars=vert:\│ " 设置split分隔符
set noswapfile  " 不需要.swp文件

" fold
set foldenable
set foldmethod=indent
set foldlevel=99

inoremap jk <Esc>
nnoremap <leader>ev  :vsplit $MYVIMRC<cr>
nnoremap <leader>sv  :source $MYVIMRC<cr>
nnoremap <c-y> viwy

" register
vnoremap p "_dP

" buffer
noremap <leader>dd :bp\|bd #<cr>      " close current buffer
noremap <leader>bo :%bd\|e#\|bd#<cr>  " close other buffers, except current
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

Plug 'shaunsingh/nord.nvim'
Plug 'mhinz/vim-startify'

" edit
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'itchyny/vim-cursorword'
Plug 'junegunn/vim-easy-align'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'mg979/vim-visual-multi'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'norcalli/nvim-colorizer.lua'

" programming
Plug 'github/copilot.vim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'andrewstuart/vim-kubernetes'
Plug 'cespare/vim-toml'
Plug 'vim-test/vim-test'
Plug 'rcarriga/vim-ultest', { 'do': ':UpdateRemotePlugins' }

Plug 'romainl/vim-cool'
Plug 'psliwka/vim-smoothie'

Plug 'wakatime/vim-wakatime'

Plug 'voldikss/vim-translator'

" terminal
Plug 'voldikss/vim-floaterm'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/bufferline.nvim'
Plug 'nvim-lualine/lualine.nvim'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

" lsp completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'windwp/nvim-autopairs'

" lsp icon
Plug 'onsails/lspkind-nvim'

" lsp format
Plug 'mhartington/formatter.nvim'

" syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" search
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ahmedkhalf/project.nvim'

" snippet.
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

call plug#end()

filetype plugin indent on

set completeopt=menu,menuone,noselect

" " Startify
let g:startify_enable_special = 0
let g:startify_lists = [
            \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
            \ { 'type': 'files',     'header': ['   Files'] },
            \]

nnoremap <leader>fgb :Git blame --date=short<cr>

" colorscheme
set noshowmode
set t_Co=256
set background=dark
let g:nord_enable_sidebar_background=v:false
let g:nord_contrast=v:true
let g:nord_disable_background=v:false
silent! colorscheme nord
set termguicolors

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


" vim-comment
nnoremap <leader>/ :Commentary<cr>
vnoremap <leader>/ :Commentary<cr>

" floaterm
noremap <leader>ft :FloatermNew --wintype=normal --position=bottom --height=20<cr>
noremap <leader>fp :FloatermNew --wintype=normal --position=right --width=0.5 --name=ipy ipython<cr>
vnoremap <leader>fs :FloatermSend<cr>
tnoremap <m-]> <c-\><c-n>:FloatermNext<cr>
tnoremap <m-[> <c-\><c-n>:FloatermPrev<cr>
tnoremap <c-w><c-w> <c-\><c-n><c-w>w

command! Lazygit FloatermNew --height=0.8 --width=0.8 --name=lazygit lazygit
nnoremap <leader>lg :Lazygit<cr>

let g:floaterm_keymap_toggle = "<m-=>"
let g:floaterm_keymap_kill = "<m-q>"
let g:floaterm_autoclose = 1
let g:floaterm_width=0.7
let g:floaterm_height=0.6

" vim-translator
nmap <silent> <M-t> <Plug>TranslateW
vmap <silent> <M-t> <Plug>TranslateWV

" splitjoin
nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>

" vim-test and vim-ultest
nmap <silent> tn :TestNearest<CR>
nmap <silent> tf :TestFile<CR>
nmap <silent> ts :TestSuite<CR>
nmap <silent> tl :TestLast<CR>
nmap <silent> tg :TestVisit<CR>
nmap <silent> tt :UltestSummary<CR>

let test#strategy = "floaterm"
let test#python#runner = 'pytest'
let test#go#runner = "gotest"

let test#python#pytest#options = "--color=yes"
let g:ultest_use_pty = 1

" lsp config
lua << EOF
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<m-k>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<m-j>', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local opts = {
    capabilities=capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }
  server:setup(opts)
end)

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = false,
  update_in_insert = false,
  severity_sort = false,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
EOF

" formatter
lua << EOF
require('formatter').setup {
  filetype = {
    python = {
      function()
        return {
          exe = "black",
          args = { '-l 120' },
          stdin = true,
        }
      end
    },
    go = {
      function()
        return {
          exe = 'goimports',
          args = { "-w", vim.api.nvim_buf_get_name(0) },
          stdin = false,
        }
      end,
    },
  }
}
EOF

augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.py,*.go FormatWrite
augroup END

" nvim-cmp.
lua <<EOF
vim.cmd [[highlight CmpItemAbbrDeprecated guifg=#D8DEE9 guibg=NONE gui=strikethrough]]
vim.cmd [[highlight CmpItemKindSnippet guifg=#BF616A guibg=NONE]]
vim.cmd [[highlight CmpItemKindUnit guifg=#D08770 guibg=NONE]]
vim.cmd [[highlight CmpItemKindProperty guifg=#A3BE8C guibg=NONE]]
vim.cmd [[highlight CmpItemKindKeyword guifg=#EBCB8B guibg=NONE]]
vim.cmd [[highlight CmpItemAbbrMatch guifg=#5E81AC guibg=NONE]]
vim.cmd [[highlight CmpItemAbbrMatchFuzzy guifg=#5E81AC guibg=NONE]]
vim.cmd [[highlight CmpItemKindVariable guifg=#8FBCBB guibg=NONE]]
vim.cmd [[highlight CmpItemKindInterface guifg=#88C0D0 guibg=NONE]]
vim.cmd [[highlight CmpItemKindText guifg=#81A1C1 guibg=NONE]]
vim.cmd [[highlight CmpItemKindFunction guifg=#B48EAD guibg=NONE]]
vim.cmd [[highlight CmpItemKindMethod guifg=#B48EAD guibg=NONE]]

local cmp = require('cmp')

local lspkind = require('lspkind')

cmp.setup({
  formatting = {
    format = lspkind.cmp_format({with_text = false, maxwidth = 50})
  },
  mapping = {
    ["<CR>"] = cmp.mapping.confirm({select = true}),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.close(),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        local copilot_keys = vim.fn["copilot#Accept"]()
        if copilot_keys ~= "" then
            vim.api.nvim_feedkeys(copilot_keys, "i", true)
        else
            fallback()
        end
      end
    end, {"i", "s"}),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, {"i", "s"}),
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

require("nvim-autopairs").setup {}
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({map_char = {tex = ""}}))
cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"
EOF

" nvim-tree.lua
lua << EOF
vim.g.nvim_tree_respect_buf_cwd = 1
require('nvim-tree').setup {
  auto_close = true,
  update_cwd = true,
  update_forcused_file = {
    enable = true,
    update_cwd = true
  },
  git = {
    enable = false,
    ignore = false,
    timeout = 500,
  },
  filters = {
    dotfiles = false,
    custom = { ".git", "node_modules", ".cache", ".DS_Store", "__pycache__", ".idea", '.dist' }
  }
}
EOF

nnoremap <leader>n :NvimTreeToggle<CR>
nnoremap <leader>m :NvimTreeFindFile<CR>

" github copilot
let g:copilot_no_tab_map = v:true
let g:copilot_assume_mapped = v:true
let g:copilot_tab_fallback = ""

" bufferline.nvim
lua << EOF
require("bufferline").setup{
  options = {
    numbers = "ordinal",
    offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "center"}},
    show_close_icon = false,
    show_buffer_close_icons = false,
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    separator_style = "thin",
  },
}
EOF

nnoremap <silent>L :BufferLineCycleNext<CR>
nnoremap <silent>H :BufferLineCyclePrev<CR>

" lualine.nvim
lua << EOF
require("lualine").setup {
  options = {
    theme = 'auto',
  },
  sections = {
    lualine_c = {
      {
        "filename", file_status=true, path=1,
      }
    },
    lualine_x = { 'encoding', 'filetype' }
  }
}
EOF

" telescope
nnoremap <silent><leader>ff <cmd>Telescope find_files<cr>
nnoremap <silent><leader>fr <cmd>Telescope live_grep<cr>
xnoremap <silent><leader>fr y:Telescope live_grep<cr><c-r>"
nnoremap <silent><leader>fb <cmd>Telescope buffers<cr>
nnoremap <silent><leader>fgf <cmd>Telescope git_status<cr>
nnoremap <silent> gr <cmd>Telescope lsp_references<cr>

" nvim-treesitter
lua << EOF
require('colorizer').setup{ '*' }
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
  }
}
EOF

" gitsigns.nvim
lua << EOF
require('gitsigns').setup {
  signs = {
    delete = {
      text = '▶'
    },
    topdelete = {
      text = '▶'
    }
  }
}
EOF

" project.nvim
lua << EOF
require("project_nvim").setup { }
require('telescope').load_extension('projects')
EOF
nnoremap <silent> <leader>p :Telescope projects<CR>

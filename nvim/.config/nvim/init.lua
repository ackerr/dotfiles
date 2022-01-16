local vim = vim

vim.g.mapleader = " "

vim.cmd("source $HOME/.config/nvim/nvim.vim")

vim.cmd([[
    if empty(glob('~/.config/nvim/autoload/plug.vim'))
      silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs 
                  \https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
]])

vim.opt.backspace = "2"
vim.opt.updatetime = 500
vim.opt.signcolumn = "yes"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 5

vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.swapfile = false -- 不需要.swp文件

-- fold
vim.opt.foldenable = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99

-- colorscheme
vim.opt.showmode = false
vim.opt.background = "dark"
vim.opt.termguicolors = true

local function keymap(mode, key, cmd)
	vim.api.nvim_set_keymap(mode, key, cmd, { silent = true, noremap = true })
end

keymap("i", "jk", "<Esc>")
keymap("n", "<leader>ev", ":edit $MYVIMRC<CR>")
keymap("n", "<leader>sv", ":source $MYVIMRC<CR>")
keymap("n", "<c-y>", "viwy")

-- " register
keymap("v", "p", '"_dP')

-- " buffer
keymap("n", "<leader>dd", ":bp|bd#<CR>") -- close current buffer
keymap("n", "<leader>do", ":%bd|e#|bd#<CR>") -- close other buffers, except current
keymap("n", "<leader>w", ":w<CR>")
keymap("v", "<leader>w", ":w<CR>")
keymap("n", "<leader>q", ":q<CR>")

-- " resize window
keymap("n", "+", ":resize +4<CR>")
keymap("n", "_", ":resize -4<CR>")
keymap("n", "=", ":vertical resize +4<CR>")
keymap("n", "-", ":vertical resize -4<CR>")

-- " move window
keymap("n", "<c-h>", "<c-w><c-h>")
keymap("n", "<c-j>", "<c-w><c-j>")
keymap("n", "<c-l>", "<c-w><c-l>")
keymap("n", "<c-k>", "<c-w><c-k>")

-- Plugin
local Plug = vim.fn["plug#"]

vim.call("plug#begin", "~/.config/nvim/plugins")

Plug("shaunsingh/nord.nvim")
Plug("goolord/alpha-nvim")

-- edit
Plug("tpope/vim-surround")
Plug("tpope/vim-repeat")
Plug("tpope/vim-commentary")
Plug("itchyny/vim-cursorword")
Plug("junegunn/vim-easy-align")
Plug("AndrewRadev/splitjoin.vim")
Plug("editorconfig/editorconfig-vim")
Plug("terryma/vim-multiple-cursors")
Plug("mg979/vim-visual-multi")
Plug("Vimjas/vim-python-pep8-indent")
Plug("norcalli/nvim-colorizer.lua")

-- programming
Plug("github/copilot.vim")
Plug("lewis6991/gitsigns.nvim")
Plug("andrewstuart/vim-kubernetes")
Plug("cespare/vim-toml")
Plug("vim-test/vim-test")
Plug("rcarriga/vim-ultest", { ["do"] = ":UpdateRemotePlugins" })

Plug("romainl/vim-cool")
Plug("psliwka/vim-smoothie")

Plug("wakatime/vim-wakatime")

Plug("voldikss/vim-translator")

-- terminal
Plug("voldikss/vim-floaterm")

Plug("kyazdani42/nvim-web-devicons")
Plug("kyazdani42/nvim-tree.lua")
Plug("akinsho/bufferline.nvim")
Plug("nvim-lualine/lualine.nvim")

-- lsp
Plug("neovim/nvim-lspconfig")
Plug("williamboman/nvim-lsp-installer")

-- lsp completion
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")
Plug("hrsh7th/nvim-cmp")
Plug("windwp/nvim-autopairs")

-- lsp icon
Plug("onsails/lspkind-nvim")

-- lsp format
Plug("jose-elias-alvarez/null-ls.nvim")

-- syntax
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
Plug("SmiteshP/nvim-gps")

-- search
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim")
Plug("nvim-telescope/telescope-project.nvim")

-- snippet.
Plug("rafamadriz/friendly-snippets")
Plug("hrsh7th/cmp-vsnip")
Plug("hrsh7th/vim-vsnip")

vim.call("plug#end")

-- nord
vim.g.nord_enable_sidebar_background = false
vim.g.nord_contrast = true
vim.g.nord_disable_background = false
vim.cmd([[ silent! colorscheme nord ]])

-- vim-commentary
keymap("n", "<leader>/", ":Commentary<CR>")
keymap("v", "<leader>/", ":Commentary<CR>")

-- vim-easy-align
keymap("x", "ga", ":EasyAlign<CR>")
keymap("n", "ga", ":EasyAlign<CR>")
vim.g.easy_align_delimiters = {
	[">"] = {
		pattern = ">>\\|\\|=>\\|>",
	},
	["/"] = {
		pattern = "//\\+\\|/\\*\\|\\*/",
		delimiter_align = "l",
		ignore_groups = { "!Comment" },
	},
	["#"] = {
		pattern = "#\\+",
		delimiter_align = "l",
		ignore_groups = { "String" },
	},
}

-- vim-floaterm
keymap("n", "<leader>ft", ":FloatermNew --wintype=normal --position=bottom --height=20<CR>")
keymap("n", "<leader>fp", ":FloatermNew --wintype=normal --position=right --width=0.5 --name=ipy ipython<CR>")
keymap("v", "<leader>fs", ":FloatermSend<CR>")
keymap("t", "<m-]>", "<c-\\><c-n>:FloatermNext<CR>")
keymap("t", "<m-[>", "<c-\\><c-n>:FloatermP<c-\\><c-n><c-w>w")
keymap("t", "<c-w><c-w>", "<c-\\><c-n><c-w>w")

-- lazygit
keymap("n", "<leader>lg", ":FloatermNew --height=0.8 --width=0.8 --name=lazygit lazygit<CR>")

vim.g.floaterm_keymap_toggle = "<m-=>"
vim.g.floaterm_keymap_kill = "<m-q>"
vim.g.floaterm_autoclose = 1
vim.g.floaterm_width = 0.7
vim.g.floaterm_height = 0.6

-- vim-translator
keymap("n", "<M-t>", ":TranslateW<CR>")
keymap("v", "<M-t>", ":TranslateW<CR>")

-- splitjoin
keymap("n", "sj", ":SplitjoinSplit<CR>")
keymap("n", "sk", ":SplitjoinJoin<CR>")

-- vim-test and vim-ultest
keymap("n", "tn", ":TestNearest<CR>")
keymap("n", "tf", ":TestFile<CR>")
keymap("n", "ts", ":TestSuite<CR>")
keymap("n", "tl", ":TestLast<CR>")
keymap("n", "tg", ":TestVisit<CR>")
keymap("n", "tt", ":UltestSummary<CR>")

vim.g["test#strategy"] = "floaterm"
vim.g["test#python#runner"] = "pytest"
vim.g["test#go#runner"] = "gotest"
vim.g["ultest_use_pty"] = 1

-- alpha.nvim
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

local function pick_color()
	local colors = { "String", "Identifier", "Keyword", "Number" }
	return colors[math.random(#colors)]
end

dashboard.section.header.opts.hl = pick_color()

dashboard.section.buttons.val = {
	dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("<Leader> ff", "  > Find file"),
	dashboard.button("<Leader> fr", "  > Find word"),
	dashboard.button("<Leader>  p", "  > Find project"),
	dashboard.button("<Leader> rr", "  > Recent", ":Telescope oldfiles<CR>"),
	dashboard.button("<Leader> ev", "  > Settings"),
	dashboard.button("q", "  > Quit", ":qa<CR>"),
}

local fortune = require("alpha.fortune")
dashboard.section.footer.val = fortune()

alpha.setup(dashboard.opts)

vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])

local function lsp_document_highlight(client)
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
            augroup lsp_document_highlight
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
            ]],
			false
		)
	end
end

local function lsp_keymap(bufnr)
	local function buf_keymap(mode, key, cmd)
		vim.api.nvim_buf_set_keymap(bufnr, mode, key, cmd, { noremap = true, silent = true })
	end

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
	buf_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
	buf_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
	buf_keymap("n", "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
	buf_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
	buf_keymap("n", "<m-k>", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
	buf_keymap("n", "<m-j>", "<cmd>lua vim.diagnostic.goto_next()<CR>")
	buf_keymap("n", "<leader>d", "<cmd>lua vim.diagnostic.disable()<CR>")
	buf_keymap("n", "<leader>cs", "<cmd>lua vim.lsp.buf.code_action()<CR>")
end

-- lsp config
local on_attach = function(client, bufnr)
	if client.name == "gopls" then
		client.resolved_capabilities.document_formatting = false
	end

	lsp_keymap(bufnr)
	lsp_document_highlight(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
	local opts = {
		capabilities = capabilities,
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		},
	}
	server:setup(opts)
end)

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = false,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- nvim-cmp.
vim.cmd([[highlight CmpItemAbbrDeprecated guifg=#D8DEE9 guibg=NONE gui=strikethrough]])
vim.cmd([[highlight CmpItemKindSnippet guifg=#BF616A guibg=NONE]])
vim.cmd([[highlight CmpItemKindUnit guifg=#D08770 guibg=NONE]])
vim.cmd([[highlight CmpItemKindProperty guifg=#A3BE8C guibg=NONE]])
vim.cmd([[highlight CmpItemKindKeyword guifg=#EBCB8B guibg=NONE]])
vim.cmd([[highlight CmpItemAbbrMatch guifg=#5E81AC guibg=NONE]])
vim.cmd([[highlight CmpItemAbbrMatchFuzzy guifg=#5E81AC guibg=NONE]])
vim.cmd([[highlight CmpItemKindVariable guifg=#8FBCBB guibg=NONE]])
vim.cmd([[highlight CmpItemKindInterface guifg=#88C0D0 guibg=NONE]])
vim.cmd([[highlight CmpItemKindText guifg=#81A1C1 guibg=NONE]])
vim.cmd([[highlight CmpItemKindFunction guifg=#B48EAD guibg=NONE]])
vim.cmd([[highlight CmpItemKindMethod guifg=#B48EAD guibg=NONE]])

local cmp = require("cmp")

local lspkind = require("lspkind")
cmp.setup({
	formatting = {
		fields = { "kind", "abbr" },
		format = lspkind.cmp_format({ with_text = false, maxwidth = 50 }),
	},
	mapping = {
		["<CR>"] = cmp.mapping.confirm({ select = true }),
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
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "vsnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

require("nvim-autopairs").setup({})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"

-- nvim-tree.lua
vim.g.nvim_tree_respect_buf_cwd = 1
vim.g.nvim_tree_icons = {
	default = "",
	symlink = "",
}
require("nvim-tree").setup({
	auto_close = true,
	update_cwd = true,
	update_forcused_file = {
		enable = true,
		update_cwd = true,
	},
	git = {
		enable = false,
		ignore = false,
		timeout = 500,
	},
	filters = {
		dotfiles = false,
		custom = { ".git", "node_modules", ".cache", ".DS_Store", "__pycache__", ".idea", ".dist" },
	},
})

keymap("n", "<leader>n", ":NvimTreeToggle<CR>")
keymap("n", "<leader>m", ":NvimTreeFindFile<CR>")

-- github copilot
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

-- bufferline.nvim
require("bufferline").setup({
	options = {
		numbers = "ordinal",
		offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
		show_close_icon = false,
		show_buffer_close_icons = false,
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level, _, _)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
		separator_style = "thin",
	},
})
keymap("n", "L", ":BufferLineCycleNext<CR>")
keymap("n", "H", ":BufferLineCyclePrev<CR>")

-- lualine.nvim
require("lualine").setup({
	options = {
		theme = "auto",
	},
	sections = {
		lualine_c = {
			{
				"filename",
				file_status = true,
				path = 1,
			},
		},
		lualine_x = { "encoding", "filetype" },
	},
})

-- telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
keymap("n", "<leader>fr", "<cmd>Telescope live_grep<CR>")
keymap("x", "<leader>fr", 'y:Telescope live_grep<CR><c-r>"')
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
keymap("n", "<leader>fg", "<cmd>Telescope git_status<CR>")
keymap("n", "gr", "<cmd>Telescope lsp_references<CR>")

-- nvim-treesitter
require("colorizer").setup({ "*" })
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		disable = {},
	},
	indent = {
		enable = true,
	},
})

-- gitsigns.nvim
require("gitsigns").setup({
	signs = {
		delete = {
			text = "▶",
		},
		topdelete = {
			text = "▶",
		},
	},
})
keymap("n", "<leader>gs", ":Gitsigns preview_hunk<CR>")
keymap("n", "<leader>gb", ":Gitsigns blame_line<CR>")

-- telescope-project
require("telescope").load_extension("project")
keymap("n", "<leader>p", ":lua require'telescope'.extensions.project.project{ display_type = 'full' }<CR>")

-- nvim-gps
require("nvim-gps").setup()
local gps = require("nvim-gps")
require("lualine").setup({
	sections = {
		lualine_c = {
			{ "filename", file_status = true, path = 1 },
			{ gps.get_location, cond = gps.is_available },
		},
	},
})

-- null-ls.nvim
local formatting = require("null-ls").builtins.formatting
local diagnostics = require("null-ls").builtins.diagnostics
require("null-ls").setup({
	sources = {
		formatting.stylua,
		formatting.goimports,
		formatting.black.with({ extra_args = { "--line-length", "120" } }),

		diagnostics.flake8,
		diagnostics.golangci_lint,
	},
})
vim.cmd([[ command! Formatting exec 'lua vim.lsp.buf.formatting()' ]])
vim.api.nvim_exec([[ autocmd BufWritePost *.py,*.go,*.lua Formatting ]], true)

--------------------------------------------
-- AUTHOR: Kristian Ebstrup Jacobsen
-- My configuration file for NeoVim.
--------------------------------------------

--------------------------------------------
-- General settings
--------------------------------------------
vim.cmd([[
  set nocompatible
  set mouse=a
  set number
  set encoding=utf-8
  set hidden

  set expandtab
  set autoindent
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2

  set termguicolors
]])

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.o.completeopt = "menuone,noinsert,noselect"

--------------------------------------------
-- Packer set-up
--------------------------------------------
-- packer initialization
require("plugins")

-- auto-compile plugins
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

--------------------------------------------
-- Misc. plugins
--------------------------------------------
require("nvim-autopairs").setup()
require("bufferline").setup()
require("nvim-web-devicons").setup()
require("lualine").setup({
	options = { theme = "auto" },
})

--------------------------------------------
-- Color scheme and syntax
--------------------------------------------
vim.cmd([[
  filetype plugin indent on
  syntax on
  colorscheme base16-nord
]])

--------------------------------------------
-- Syntax highlighting
--------------------------------------------
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"json",
		"lua",
		"markdown",
		"python",
		"regex",
		"rust",
		"vim",
		"yaml",
	},
	highlight = { enable = true },
	indent = { enable = true },
})

--------------------------------------------
-- Completion
--------------------------------------------
local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif require("luasnip").expand_or_jumpable() then
				require("luasnip").expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "nvim_lsp_signature_help" },
	}),
})

-- Command line completion
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = { { name = "buffer" } },
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

--------------------------------------------
-- Formatting
--------------------------------------------
local diagnostics = require("null-ls").builtins.diagnostics
local formatting = require("null-ls").builtins.formatting
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

require("null-ls").setup({
	sources = {
		formatting.black,
		formatting.rustfmt,
		formatting.stylua,
	},
	on_attach = function(client, bufnr)
		if client.name == "tsserver" or client.name == "rust-analyzer" or client.name == "pyright" then
			client.resolved_capabilities.document_formatting = false
			client.resolved_capabilities.document_range_formatting = false
		end

		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				callback = function()
					vim.lsp.buf.format()
				end,
			})
		end
	end,
})

---------------------------------
-- Auto commands
---------------------------------
-- vim.cmd([[
--  autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
-- ]])

---------------------------------
-- Language servers
---------------------------------
require("nvim-lsp-installer").setup({})

local lspconfig = require("lspconfig")
local caps = vim.lsp.protocol.make_client_capabilities()
local no_format = function(client, bufnr)
	client.server_capabilities.document_formatting = false
end

-- Capabilities
caps.textDocument.completion.completionItem.snippetSupport = true

-- Python
lspconfig.pyright.setup({
	capabilities = caps,
	on_attach = no_format,
})

-- Rust (see https://github.com/sharksforarms/neovim-rust/blob/master/neovim-init-lsp-cmp-rust-tools.lua)
local opts = {
	tools = {
		runnables = {
			use_telescope = true,
		},
		inlay_hints = {
			auto = true,
			show_parameter_hints = false,
			parameter_hints_prefix = "",
			other_hints_prefix = "",
		},
	},

	-- all the opts to send to nvim-lspconfig
	-- these override the defaults set by rust-tools.nvim
	-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
	server = {
		-- on_attach is a callback called when the language server attachs to the buffer
		on_attach = on_attach,
		settings = {
			-- to enable rust-analyzer settings visit:
			-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
			["rust-analyzer"] = {
				-- enable clippy on save
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
}
require("rust-tools").setup(opts)

-- have a fixed column for the diagnostics to appear in
-- this removes the jitter when warnings/errors flow in
vim.wo.signcolumn = "yes"

-- " Set updatetime for CursorHold
-- " 300ms of no cursor movement to trigger CursorHold
-- set updatetime=300
vim.opt.updatetime = 300

-- Fortran
lspconfig.fortls.setup({
	cmd = {
		"fortls",
		"--notify_init",
		"--hover_signature",
		"--hover_language=fortran",
		"--use_signature_help",
		"--lowercase_intrinsics",
	},
})

---------------------------------
-- Floating diagnostics message
---------------------------------
vim.diagnostic.config({
	float = { source = "always", border = border },
	virtual_text = false,
	signs = true,
})

---------------------------------
-- Auto commands
---------------------------------
vim.cmd([[ autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

---------------------------------
-- Key bindings
---------------------------------
local map = vim.api.nvim_set_keymap
local kmap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader
vim.g.mapleader = " "

-- Vim
map("n", "<C-q>", ":q!<CR>", opts)
map("n", "<F4>", ":bd<CR>", opts)
map("n", "<F6>", ":sp<CR>:terminal<CR>", opts)
map("n", "<Tab>", ":BufferLineCycleNext<CR>", opts)
map("n", "<S-Tab>", "BufferLineCyclePrev<CR>", opts)
map("n", "<silent> <Tab>", ":tabnew<CR>", opts)

-- Diagnostics
kmap("n", "<space>e", vim.diagnostic.open_float, opts)
kmap("n", "[d", vim.diagnostic.goto_prev, opts)
kmap("n", "]d", vim.diagnostic.goto_next, opts)
kmap("n", "<space>q", vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	kmap("n", "gD", vim.lsp.buf.declaration, bufopts)
	kmap("n", "gd", vim.lsp.buf.definition, bufopts)
	kmap("n", "K", vim.lsp.buf.hover, bufopts)
	kmap("n", "gi", vim.lsp.buf.implementation, bufopts)
	kmap("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	kmap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	kmap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	kmap("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	kmap("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	kmap("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	kmap("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	kmap("n", "gr", vim.lsp.buf.references, bufopts)
	kmap("n", "<space>f", vim.lsp.buf.format, bufopts)
end

-- Python environment
vim.cmd([[
  let g:python3_host_prog = "/home/kreb/.local/venv/nvim/bin/python3"
]])

-- NERDTree easy access
vim.cmd([[
  nnoremap <leader>, :NERDTreeToggle<CR>
]])

-- Key-bindings for easy parenthesis surround
vim.cmd([[
  nnoremap <leader>o viw<esc>a)<esc>hbi(<esc>lel
  nnoremap <leader>p viw<esc>a]<esc>hbi[<esc>lel
  nnoremap <leader>i viw<esc>a}<esc>hbi{<esc>lel
]])

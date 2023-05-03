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

-- set leader
vim.g.mapleader = " "

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
require("lualine").setup()

-- language servers
require("lspconfig").rust_analyzer.setup({})
require("lspconfig").jedi_language_server.setup({})
require("lspconfig").fortls.setup({})

--------------------------------------------
-- Syntax highlighting
--------------------------------------------
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
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
-- Color scheme and syntax
--------------------------------------------
vim.cmd([[
  filetype plugin indent on
  syntax on
  let g:lightline = {
    \ 'colorscheme': 'base16-nord',
    \ }
  colorscheme base16-nord
]])

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
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
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
		if client.name == "tsserver" or client.name == "rust_analyzer" or client.name == "pyright" then
			client.resolved_capabilities.document_formatting = false
		end

		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				callback = function()
					vim.lsp.buf.formatting_sync()
				end,
			})
		end
	end,
})

---------------------------------
-- Auto commands
---------------------------------
vim.cmd([[
  autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync() 
]])

---------------------------------
-- Language servers
---------------------------------
local lspconfig = require("lspconfig")
local caps = vim.lsp.protocol.make_client_capabilities()
local no_format = function(client, bufnr)
	client.resolved_capabilities.document_formatting = false
end

-- Capabilities
caps.textDocument.completion.completionItem.snippetSupport = true

-- Python
lspconfig.jedi_language_server.setup({
	capabilities = caps,
	on_attach = no_format,
})

-- Rust
lspconfig.rust_analyzer.setup({
	capabilities = snip_caps,
	on_attach = no_format,
})

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
map("n", "<S-Tab>", "gT", opts)
map("n", "<Tab>", "gt", opts)
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
	kmap("n", "<space>f", vim.lsp.buf.formatting, bufopts)
end

-- Python environment
vim.cmd([[
  let g:python3_host_prog = "/home/kreb/.local/venv/nvim/bin/python3"
]])

-- NERDTree easy access
vim.cmd([[
  nnoremap <leader>, :NERDTreeToggle<CR>

  nnoremap <leader>o viw<esc>a)<esc>hbi(<esc>lel
  nnoremap <leader>p viw<esc>a]<esc>hbi[<esc>lel
  nnoremap <leader>i viw<esc>a}<esc>hbi{<esc>lel
]])

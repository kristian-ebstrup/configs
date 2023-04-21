-- Author: Kristian Ebstrup Jacobsen
-- My NeoVim init.lua file.

-- general settings
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

-- autoformat
vim.cmd([[
  autocmd BufWritePre *\(.py\)\@<! lua vim.lsp.buf.format()

  augroup black_on_save
    autocmd!
    autocmd BufWritePre *.py Black
  augroup end
]])

-- set leader
vim.g.mapleader = " "

-- packer initialization
-- load ~/.config/nvim/lua/plugins.lua
require('plugins')

-- auto-compile plugins
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])


-- language servers
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.jedi_language_server.setup{}
require'lspconfig'.fortls.setup{}

-- colorschemes
vim.cmd([[
  let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ }
  colorscheme base16-nord
]])

-- Mappings from https://github.com/neovim/nvim-lspconfig.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } 
  end, bufopts)
end

-- snippets
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'rust_analyzer', 'jedi_language_server', 'fortls'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- configure fortls separately to use lower-case
lspconfig.fortls.setup{
  cmd = {
    "fortls", 
    "--notify_init", 
    "--hover_signature", 
    "--hover_language=fortran", 
    "--use_signature_help", 
    "--lowercase_intrinsics" 
  }
}


-- luasnip setup
local luasnip = require('luasnip')

-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- inlay-hints and rust-tools setup
local rt = require("rust-tools")

-- Enable inlay hints auto update and set them for all the buffers
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<Leader>m", rt.hover_actions.hover_actions, { buffer = bufnr })
    end,
  }
})
rt.inlay_hints.enable()

-- Python environment
vim.cmd([[
  let g:python3_host_prog = "/home/kreb/.local/venv/nvim/bin/python3"
]])

-- Misc key-mappings
vim.cmd([[
  nnoremap <leader>, :NERDTreeToggle<CR>

  nnoremap <leader>o viw<esc>a)<esc>hbi(<esc>lel
  nnoremap <leader>p viw<esc>a]<esc>hbi[<esc>lel
  nnoremap <leader>i viw<esc>a}<esc>hbi{<esc>lel
]])


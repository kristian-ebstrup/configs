-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- lsp set-up
  use 'neovim/nvim-lspconfig'
  use 'simrat39/rust-tools.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'mfussenegger/nvim-dap'
  use 'simrat39/inlay-hints.nvim'
  use 'psf/black'

  -- file exploration
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  use 'preservim/nerdtree'

  -- snippets
  use 'hrsh7th/nvim-cmp'  -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'  -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip'  -- Snippets plugin

  -- color schemes
  use 'chriskempson/base16-vim'
  use 'itchyny/lightline.vim'
  use 'projekt0n/github-nvim-theme'

  -- git-related
  use "airblade/vim-gitgutter"

  -- markdown preview
  -- install without yarn or npm
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
end)

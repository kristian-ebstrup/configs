-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- plugin manager
	use("wbthomason/packer.nvim")

	-- auto-completion
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use("hrsh7th/nvim-cmp") -- Autocompletion plugin

	-- snippets engines
	use("L3MON4D3/LuaSnip") -- Snippets plugin
	use("saadparwaiz1/cmp_luasnip") -- Snippets source for nvim-cmp

	-- lsp
	use("neovim/nvim-lspconfig")
	use("williamboman/nvim-lsp-installer")

	-- misc. lsp-related
	use("mfussenegger/nvim-dap")

	-- extra Rust-related functionality
	use("simrat39/rust-tools.nvim")

	-- formatting
	use("jose-elias-alvarez/null-ls.nvim")

	-- dependencies
	use("nvim-lua/plenary.nvim")
	use("MunifTanjim/nui.nvim")
	use("kyazdani42/nvim-web-devicons")

	-- syntax parser
	use("nvim-treesitter/nvim-treesitter")

	-- file exploration
	use("junegunn/fzf")
	use("junegunn/fzf.vim")
	use("preservim/nerdtree")
	use("nvim-telescope/telescope.nvim")

	-- interface
	use("akinsho/bufferline.nvim")
	use("nvim-lualine/lualine.nvim")

	-- utilities
	use("windwp/nvim-autopairs")
	use("airblade/vim-gitgutter")

	-- color schemes
	use("RRethy/nvim-base16")
	use("projekt0n/github-nvim-theme")

	-- markdown preview
	-- install without yarn or npm
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})
end)

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		enabled = not vim.g.vscode,
		dependencies = {
			"rebelot/kanagawa.nvim",
			"folke/tokyonight.nvim",
			"EdenEast/nightfox.nvim",
			"neanias/everforest-nvim",
			"sainnhe/gruvbox-material",
			"rose-pine/neovim",
		},
		config = function()
			vim.cmd.colorscheme("nordfox")
		end,
	},
	{
		"vague2k/vague.nvim",
		lazy = false,
		priority = 1000,
		enabled = false,
		config = function()
			require("vague").setup({
				style = {
					strings = "none",
				},
			})
			vim.cmd.colorscheme("vague")
		end,
	},
	{
		"datsfilipe/vesper.nvim",
		lazy = false,
		priority = 1000,
		enabled = false,
		config = function()
			require("vesper").setup({
				transparent = false, -- Boolean: Sets the background to transparent
				italics = {
					comments = true,
					functions = true,
					keywords = false,
					strings = false,
					variables = false,
				},
				overrides = {}, -- A dictionary of group names, can be a function returning a dictionary or a table.
				palette_overrides = {},
			})
			vim.cmd.colorscheme("vesper")
		end,
	},
}

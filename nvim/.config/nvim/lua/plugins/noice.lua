-- https://github.com/folke/noice.nvim
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		lsp = {
			progress = { enabled = false },
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			opts = {
				timeout = 400, -- milliseconds
				render = "wrapped-compact", -- wraps around
				max_width = 40, -- in chars i suppose
				stages = "fade",
			},
		},
	},
	enabled = not vim.g.vscode,
}

-- https://github.com/webhooked/kanso.nvim
return {
	{
		"webhooked/kanso.nvim",
		lazy = false,
		priority = 1000,
		enabled = not vim.g.vscode,
		config = function()
			vim.cmd.colorscheme("kanso-ink") -- mid dark
			-- vim.cmd.colorscheme("kanso") -- full dark
			-- vim.cmd.colorscheme("kanso-mist") -- a bit lighter
		end,
	},
	-- "EdenEast/nightfox.nvim",
	-- "sainnhe/gruvbox-material",
	-- "rose-pine/neovim",
}

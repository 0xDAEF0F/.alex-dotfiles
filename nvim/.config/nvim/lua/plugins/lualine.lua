-- https://github.com/nvim-lualine/lualine.nvim
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			disabled_filetypes = {
				statusline = { "neo-tree", "Outline" },
				winbar = { "neo-tree", "Outline" },
			},
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = {},
			lualine_c = {
				{ "filename", path = 1 },
			},
			lualine_x = {
				{
					"lsp_status",
					ignore_lsp = { "biome", "tailwindcss" },
				},
			},
			lualine_y = {},
			lualine_z = { "branch" },
		},
	},
	enabled = not vim.g.vscode,
}

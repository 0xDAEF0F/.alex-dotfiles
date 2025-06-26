return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		sections = {
			lualine_c = {
				{ "filename", path = 1 },
			},
			lualine_x = {
				{
					"lsp_status",
					icon = "",
					symbols = {
						spinner = {
							"⠋",
							"⠙",
							"⠹",
							"⠸",
							"⠼",
							"⠴",
							"⠦",
							"⠧",
							"⠇",
							"⠏",
						},
						done = "",
						separator = " ",
					},
					ignore_lsp = { "biome", "tailwindcss" },
				},
				{
					"filetype",
					colored = true,
					icon_only = true,
					icon = { align = "right" },
				},
			},
		},
	},
	enabled = not vim.g.vscode,
}

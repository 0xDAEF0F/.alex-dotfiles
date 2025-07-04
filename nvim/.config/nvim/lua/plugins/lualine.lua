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
			lualine_b = {
				{
					function()
						local cwd = vim.fn.getcwd()
						-- Check if we're in a git repo
						local git_dir = vim.fn.finddir(".git", cwd .. ";")
						if git_dir ~= "" then
							-- We're in a git repo, show just the project name
							return "󰊢 " .. vim.fn.fnamemodify(cwd, ":t")
						else
							-- Not in a git repo, show the full path with ~ for home
							local home = vim.fn.expand("~")
							local shortened = cwd:gsub("^" .. vim.fn.escape(home, "\\"), "~")
							return "󰉋 " .. shortened
						end
					end,
				},
			},
			lualine_c = {
				{ "filename" },
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

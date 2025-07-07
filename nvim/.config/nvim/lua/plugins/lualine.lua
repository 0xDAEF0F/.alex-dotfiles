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
							-- Get the full path to the .git directory
							local git_path = vim.fn.fnamemodify(git_dir, ":p")
							-- Get the parent directory (the actual git repo root)
							local git_root = vim.fn.fnamemodify(git_path, ":h:h")
							-- Show the name of the git repo directory
							return "󰊢 " .. vim.fn.fnamemodify(git_root, ":t")
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
	-- enabled = not vim.g.vscode,
	enabled = false,
}

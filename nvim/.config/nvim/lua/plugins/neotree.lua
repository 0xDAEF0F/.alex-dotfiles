-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		-- {"3rd/image.nvim", opts = {}},
	},

	lazy = false, -- neo-tree will lazily load itself

	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		vim.keymap.set("n", "<C-e>", "<cmd>Neotree toggle<CR>")

		require("neo-tree").setup({
			close_if_last_window = true,
			use_libuv_file_watcher = true,
			enable_diagnostics = true,
			default_component_configs = {
				diagnostics = {
					symbols = {
						hint = "",
						info = "",
						warn = "",
						error = "",
					},
				},
				name = {
					use_git_status_colors = false, -- disable yellow text for modified files
				},
				git_status = {
					symbols = {
						unstaged = "", -- remove unstaged icon to avoid duplication with modified
					},
				},
			},
			window = {
				width = 30,
				mappings = {
					["s"] = function()
						require("flash").jump()
					end,
					["<C-f>"] = function()
						require("fzf-lua").oldfiles()
					end,
				},
			},
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
		})
	end,

	enabled = not vim.g.vscode,
}

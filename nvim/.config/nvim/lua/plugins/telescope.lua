-- https://github.com/nvim-telescope/telescope.nvim
-- TEMPORARILY DISABLED in favor of fzf-lua
return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				mappings = {
					n = {
						["dd"] = require("telescope.actions").delete_buffer,
					},
				},
				layout_config = {
					horizontal = {
						preview_width = 0.55, -- in percentage
						vertical = { width = 0.5 },
					},
				},
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		local builtin = require("telescope.builtin")

		-- most used (telescope)
		vim.keymap.set("n", "<leader>s.", function()
			builtin.oldfiles({
				cwd_only = true,
				layout_strategy = "vertical",
			})
		end)
		vim.keymap.set("n", "<leader><leader>", builtin.buffers)
		vim.keymap.set("n", "<leader>sf", function()
			local dotfiles_path = vim.fn.expand("~/.alex-dotfiles")
			if vim.fn.getcwd() == dotfiles_path then
				builtin.find_files({
					hidden = true,
					layout_strategy = "vertical",
					no_ignore = true,
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--no-ignore",
						"--glob",
						"!.git/**",
					},
					prompt_title = "Find Files (All Files)",
				})
			else
				builtin.find_files({ layout_strategy = "vertical" })
			end
		end)

		-- search including hidden files and .gitignore (excluding .git) in ~/.alex-dotfiles
		-- vim.keymap.set("n", "<leader>sg", builtin.live_grep)
		vim.keymap.set("n", "<leader>sg", function()
			local dotfiles_path = vim.fn.expand("~/.alex-dotfiles")
			if vim.fn.getcwd() == dotfiles_path then
				builtin.live_grep({
					additional_args = { "--hidden", "--no-ignore", "--glob", "!.git/**" },
					layout_strategy = "vertical",

					prompt_title = "Live Grep (All Files)",
				})
			else
				builtin.live_grep({ layout_strategy = "vertical" })
			end
		end)

		-- searches in neovim config
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end)

		vim.keymap.set("n", "<leader>sh", builtin.help_tags)
		vim.keymap.set("n", "<leader>sk", builtin.keymaps)
		vim.keymap.set("n", "<leader>ss", builtin.builtin)
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics)
		vim.keymap.set("n", "<leader>sr", builtin.resume)
	end,

	-- enabled = not vim.g.vscode,
	enabled = false,
}

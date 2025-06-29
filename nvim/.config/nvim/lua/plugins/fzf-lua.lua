-- https://github.com/ibhagwan/fzf-lua
return {
	"ibhagwan/fzf-lua",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			winopts = {
				height = 0.85,
				width = 0.80,
				row = 0.35,
				col = 0.50,
				preview = {
					layout = "vertical",
					vertical = "down:55%",
					scrollbar = "float",
				},
			},
			keymap = {
				builtin = {
					["<C-d>"] = "preview-page-down",
					["<C-u>"] = "preview-page-up",
				},
			},
			files = {
				fd_opts = "--color never --type f --type l --hidden --exclude .git",
			},
			grep = {
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore --glob '!.git/*' --glob '!**/target/*' --glob '!bin/*' --glob '!dist/*' --glob '!*.lock' --glob '!package-lock.json' --glob '!**/node_modules/*'",
			},
			oldfiles = {
				prompt = "History❯ ",
				cwd_only = true,
				include_current_session = true,
			},
			buffers = {
				sort_lastused = true,
			},
		})

		-- Most used mappings
		vim.keymap.set("n", "<leader><leader>", fzf.buffers)

		vim.keymap.set("n", "<C-f>", fzf.oldfiles)
		vim.keymap.set("n", "<C-.>", fzf.files)
		vim.keymap.set("n", "<C-g>", fzf.live_grep)

		vim.keymap.set("n", "<leader>ss", fzf.builtin)

		vim.keymap.set("n", "<leader>sr", fzf.resume)

		-- Search in neovim config
		vim.keymap.set("n", "<leader>sn", function()
			fzf.files({
				cwd = vim.fn.stdpath("config"),
				previewer = "builtin",
			})
		end, { desc = "Search Neovim config files" })

		-- Other search mappings
		vim.keymap.set(
			"n",
			"<leader>sh",
			fzf.help_tags,
			{ desc = "Search help tags" }
		)

		vim.keymap.set(
			"n",
			"<leader>sd",
			fzf.diagnostics_document,
			{ desc = "Search diagnostics" }
		)
	end,

	enabled = not vim.g.vscode,
}

-- https://github.com/ibhagwan/fzf-lua
return {
	"ibhagwan/fzf-lua",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzf = require("fzf-lua")

		-- Configure fzf-lua
		fzf.setup({
			winopts = {
				height = 0.85,
				width = 0.80,
				row = 0.35,
				col = 0.50,
				preview = {
					layout = "vertical",
					vertical = "down:55%",
				},
			},
			files = {
				-- Include hidden files and ignored files
				fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude target --exclude bin --exclude dist",
			},
			grep = {
				-- Grep options similar to telescope
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore --glob '!.git/*' --glob '!target/*' --glob '!bin/*' --glob '!dist/*' --glob '!*.lock' --glob '!package-lock.json' --glob '!**/node_modules/*'",
			},
			oldfiles = {
				include_current_session = true,
			},
			buffers = {
				-- Sort buffers by most recently used
				sort_lastused = true,
			},
		})

		-- Most used mappings
		vim.keymap.set("n", "<C-.>", function()
			fzf.oldfiles()
		end, { desc = "Search recent files" })

		vim.keymap.set(
			"n",
			"<leader><leader>",
			fzf.buffers,
			{ desc = "Search buffers" }
		)

		vim.keymap.set("n", "<C-f>", fzf.files, { desc = "Find files" })

		vim.keymap.set("n", "<C-g>", fzf.live_grep, { desc = "Live grep" })

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
		vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "Search keymaps" })
		vim.keymap.set(
			"n",
			"<leader>ss",
			fzf.builtin,
			{ desc = "Search builtin pickers" }
		)
		vim.keymap.set(
			"n",
			"<leader>sd",
			fzf.diagnostics_document,
			{ desc = "Search diagnostics" }
		)
		vim.keymap.set(
			"n",
			"<leader>sr",
			fzf.resume,
			{ desc = "Resume last search" }
		)
	end,

	enabled = not vim.g.vscode,
}

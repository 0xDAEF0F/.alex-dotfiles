return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- {"3rd/image.nvim", opts = {}},
	},

	lazy = false, -- neo-tree will lazily load itself

	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		vim.keymap.set("n", "<C-e>", "<cmd>Neotree toggle<CR>")

		-- auto-quit when only neo-tree remains
		vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "WinClosed" }, {
			callback = function()
				local wins = vim.api.nvim_list_wins()
				local real_wins = {}

				for _, win in ipairs(wins) do
					local buf = vim.api.nvim_win_get_buf(win)
					local ft = vim.api.nvim_buf_get_option(buf, "filetype")
					if ft ~= "neo-tree" then
						table.insert(real_wins, win)
					end
				end

				if #real_wins == 0 and #wins > 0 then
					vim.cmd("qa")
				end
			end,
		})

		-- open neo-tree on startup, close empty buffer
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if vim.fn.argc() == 0 then
					local empty_buf = vim.api.nvim_get_current_buf()
					vim.cmd("Neotree show")
					vim.schedule(function()
						if
							vim.api.nvim_buf_is_valid(empty_buf)
							and vim.api.nvim_buf_get_name(empty_buf) == ""
						then
							vim.api.nvim_buf_delete(empty_buf, { force = true })
						end
					end)
				end
			end,
		})

		require("neo-tree").setup({
			close_if_last_window = false, -- we handle this with autocmd above
			use_libuv_file_watcher = true,
			window = {
				width = 30,
				mappings = {
					["s"] = function()
						require("flash").jump()
					end,
					["<C-f>"] = function()
						require("fzf-lua").files()
					end,
				},
			},
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
				filtered_items = {
					hide_hidden = false,
					hide_gitignored = false,
				},
			},
		})
	end,

	enabled = not vim.g.vscode,
}

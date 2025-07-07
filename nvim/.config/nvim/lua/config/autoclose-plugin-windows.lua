-- Auto-close plugin windows when they're the last windows
local M = {}

function M.setup()
	vim.api.nvim_create_autocmd("BufEnter", {
		nested = true,
		callback = function()
			-- Only proceed if we entered a plugin window
			local plugin_filetypes = {
				["neo-tree"] = true,
				["Outline"] = true,
			}

			local wins = vim.api.nvim_list_wins()
			local non_plugin_wins = 0
			local plugin_wins = {}

			for _, win in ipairs(wins) do
				local buf = vim.api.nvim_win_get_buf(win)
				local ft = vim.api.nvim_buf_get_option(buf, "filetype")
				local is_floating = vim.api.nvim_win_get_config(win).relative ~= ""

				if not is_floating then
					if plugin_filetypes[ft] then
						table.insert(plugin_wins, win)
					else
						non_plugin_wins = non_plugin_wins + 1
					end
				end
			end

			-- If only plugin windows remain, quit
			if non_plugin_wins == 0 and #plugin_wins > 0 then
				vim.cmd("quit")
			end
		end,
	})
end

return M


-- https://github.com/b0o/incline.nvim
return {
	"b0o/incline.nvim",
	config = function()
		local devicons = require("nvim-web-devicons")
		-- what is this for?
		-- local helpers = require("incline.helpers")

		-- Color scheme constants
		local colors = {
			bg = {
				main = "#1F1F28",
				active_buffer = "#7FB4CA",
			},
			fg = {
				active = "#16161D",
				inactive = "#9CA0B0",
				separator = "#565656",
				modified = "#C4746E",
			},
			modes = {
				n = { text = "[N]", color = "#7FB4CA" },
				i = { text = "[I]", color = "#8A9A7B" },
				v = { text = "[V]", color = "#A292A3" },
				V = { text = "[V]", color = "#A292A3" },
				R = { text = "[R]", color = "#C4746E" },
				c = { text = "[C]", color = "#C4B28A" },
				t = { text = "[T]", color = "#8EA4A2" },
			},
		}

		-- Helper functions
		local function get_listed_buffers()
			local buffers = {}
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
					table.insert(buffers, buf)
				end
			end
			return buffers
		end

		local function get_buffer_name(buf)
			local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
			return filename ~= "" and filename or "[No Name]"
		end

		local function get_mode_info(mode)
			local mode_info = colors.modes[mode]
			if mode_info then
				return mode_info.text, mode_info.color
			end
			return "[" .. mode:upper() .. "]", "#393B44"
		end

		local function get_git_branch(path)
			local handle = io.popen(
				"git -C "
					.. vim.fn.shellescape(path)
					.. " branch --show-current 2>/dev/null"
			)
			if not handle then
				return ""
			end
			local branch = handle:read("*a"):gsub("\n", "")
			handle:close()
			return branch
		end

		-- Setup incline for top bar (buffers display)
		require("incline").setup({
			window = {
				placement = {
					horizontal = "right",
					vertical = "top",
				},
				padding = 0,
				margin = { horizontal = 0 },
			},
			render = function()
				local buffers = get_listed_buffers()
				local current_buf = vim.api.nvim_get_current_buf()
				local elements = {}

				-- Add each buffer to the display
				for i, buf in ipairs(buffers) do
					local filename = get_buffer_name(buf)
					local modified = vim.bo[buf].modified
					local is_current = buf == current_buf

					-- Get file icon
					local icon, icon_color = devicons.get_icon_color(
						filename,
						vim.fn.fnamemodify(filename, ":e"),
						{ default = true }
					)

					-- Buffer separator
					if i > 1 then
						table.insert(elements, { " │ ", guifg = colors.fg.separator })
					end

					-- Buffer content
					if is_current then
						-- For active buffer, apply blue background to icon and filename
						table.insert(elements, {
							" " .. icon .. " " .. filename .. " ",
							guibg = colors.bg.active_buffer,
							guifg = colors.fg.active,
							gui = "bold",
						})
						-- Modified indicator with different color
						if modified then
							table.insert(elements, {
								"[+]",
								guifg = colors.fg.modified,
								gui = "bold",
							})
						end
					else
						-- For inactive buffers
						table.insert(elements, {
							" " .. icon .. " ",
							guifg = icon_color or colors.fg.inactive,
						})
						table.insert(elements, {
							filename .. " ",
							guifg = colors.fg.inactive,
						})
						if modified then
							table.insert(elements, {
								"[+]",
								guifg = colors.fg.modified,
							})
						end
					end
				end

				return {
					elements,
					guibg = colors.bg.main,
				}
			end,
		})

		-- Custom bottom bar implementation
		local bottom_bars = {}

		local function update_bottom_bar_content(win, float_win, buf)
			if
				not vim.api.nvim_win_is_valid(win)
				or not vim.api.nvim_win_is_valid(float_win)
			then
				return
			end

			-- Update position in case window was resized
			local current_win_width = vim.api.nvim_win_get_width(win)
			local current_win_height = vim.api.nvim_win_get_height(win)
			local current_win_pos = vim.api.nvim_win_get_position(win)

			-- Get current mode
			local mode = vim.fn.mode()
			local mode_text, mode_color = get_mode_info(mode)

			-- Get git branch
			local git_branch = get_git_branch(vim.fn.expand("%:p:h"))

			-- Format content with mode highlighting
			local ns_id = vim.api.nvim_create_namespace("bottom_bar_" .. win)
			vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)

			-- Build content
			local mode_section = " " .. mode_text .. " "
			local separator = " │ "
			local git_section = git_branch ~= "" and "󰊢 " .. git_branch
				or "No Git "
			local content = mode_section .. separator .. git_section

			-- Update bar width based on content length
			local bar_width = vim.fn.strwidth(content) + 2

			-- Update window position and size
			vim.api.nvim_win_set_config(float_win, {
				relative = "editor",
				width = bar_width,
				height = 1,
				row = current_win_pos[1] + current_win_height - 1,
				col = current_win_pos[2] + current_win_width - bar_width,
			})

			vim.api.nvim_buf_set_lines(buf, 0, -1, false, { content })

			-- Apply mode color highlight
			local hl_group = "BottomBarMode" .. win
			vim.api.nvim_set_hl(
				0,
				hl_group,
				{ bg = mode_color, fg = colors.fg.active, bold = true }
			)
			vim.api.nvim_buf_add_highlight(buf, ns_id, hl_group, 0, 0, #mode_section)

			-- Apply normal highlight for the rest
			vim.api.nvim_buf_add_highlight(
				buf,
				ns_id,
				"StatusLine",
				0,
				#mode_section,
				-1
			)
			vim.api.nvim_win_set_option(float_win, "winhl", "Normal:StatusLine")
		end

		local function create_bottom_bar(win)
			if bottom_bars[win] and vim.api.nvim_win_is_valid(bottom_bars[win]) then
				return
			end

			local buf = vim.api.nvim_create_buf(false, true)
			vim.bo[buf].bufhidden = "wipe"

			local win_width = vim.api.nvim_win_get_width(win)
			local win_height = vim.api.nvim_win_get_height(win)
			local win_pos = vim.api.nvim_win_get_position(win)

			-- Calculate width based on content (approximate)
			local bar_width = 35 -- Adjust as needed for mode + git branch

			local float_win = vim.api.nvim_open_win(buf, false, {
				relative = "editor",
				width = bar_width,
				height = 1,
				row = win_pos[1] + win_height - 1,
				col = win_pos[2] + win_width - 1, -- Position at right edge
				focusable = false,
				style = "minimal",
				border = "none",
				noautocmd = true,
			})

			bottom_bars[win] = float_win

			-- Initial content update
			update_bottom_bar_content(win, float_win, buf)

			-- Set up autocmds for this window
			local group =
				vim.api.nvim_create_augroup("BottomBar_" .. win, { clear = true })
			vim.api.nvim_create_autocmd({
				"CursorMoved",
				"CursorMovedI",
				"BufEnter",
				"ModeChanged",
				"WinResized",
			}, {
				group = group,
				pattern = "*",
				callback = function()
					update_bottom_bar_content(win, float_win, buf)
				end,
			})

			vim.api.nvim_create_autocmd("WinClosed", {
				group = group,
				pattern = tostring(win),
				callback = function()
					if
						bottom_bars[win] and vim.api.nvim_win_is_valid(bottom_bars[win])
					then
						vim.api.nvim_win_close(bottom_bars[win], true)
					end
					bottom_bars[win] = nil
					vim.api.nvim_del_augroup_by_id(group)
				end,
			})
		end

		-- Create bottom bars for existing windows and new ones
		vim.api.nvim_create_autocmd({ "WinNew", "WinEnter", "VimEnter" }, {
			callback = function()
				local win = vim.api.nvim_get_current_win()
				if vim.api.nvim_win_get_config(win).relative == "" then
					create_bottom_bar(win)
				end
			end,
		})

		-- Initial creation for all windows
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_config(win).relative == "" then
				create_bottom_bar(win)
			end
		end
	end,
	event = "VeryLazy",
	enabled = not vim.g.vscode,
}

-- https://github.com/andymass/vim-matchup

local M = {}

function M.setup()
	-- create highlight group that matches the built-in MatchParen
	vim.api.nvim_set_hl(0, "ScopeMatch", { link = "MatchParen" })

	-- namespace for our highlights
	local ns = vim.api.nvim_create_namespace("scope_highlight")

	local function find_enclosing_brackets()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local row = cursor_pos[1] - 1
		local col = cursor_pos[2]

		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		if #lines == 0 then
			return nil
		end

		-- stack to track bracket pairs
		local stack = {}
		local bracket_pairs = {
			["("] = ")",
			["["] = "]",
			["{"] = "}",
		}
		local closing_brackets = {
			[")"] = "(",
			["]"] = "[",
			["}"] = "{",
		}

		-- search backwards from cursor position
		for r = row, 0, -1 do
			local line = lines[r + 1]
			local start_col = (r == row) and col or #line - 1

			for c = start_col, 0, -1 do
				local char = line:sub(c + 1, c + 1)

				if closing_brackets[char] then
					-- found a closing bracket, add to stack
					table.insert(stack, char)
				elseif bracket_pairs[char] then
					-- found an opening bracket
					if #stack > 0 and stack[#stack] == bracket_pairs[char] then
						-- this matches something in our stack, pop it
						table.remove(stack)
					else
						-- this is our opening bracket!
						-- now find the matching closing bracket
						local close_pos =
							find_matching_close(lines, r, c, char, bracket_pairs[char])
						if close_pos then
							return { open = { r, c }, close = close_pos }
						end
					end
				end
			end
		end

		return nil
	end

	function find_matching_close(
		lines,
		start_row,
		start_col,
		open_char,
		close_char
	)
		local count = 1

		for r = start_row, #lines - 1 do
			local line = lines[r + 1]
			local start_c = (r == start_row) and start_col + 1 or 0

			for c = start_c, #line - 1 do
				local char = line:sub(c + 1, c + 1)

				if char == open_char then
					count = count + 1
				elseif char == close_char then
					count = count - 1
					if count == 0 then
						return { r, c }
					end
				end
			end
		end

		return nil
	end

	local function highlight_scope()
		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

		local brackets = find_enclosing_brackets()
		if brackets then
			vim.api.nvim_buf_add_highlight(
				0,
				ns,
				"ScopeMatch",
				brackets.open[1],
				brackets.open[2],
				brackets.open[2] + 1
			)
			vim.api.nvim_buf_add_highlight(
				0,
				ns,
				"ScopeMatch",
				brackets.close[1],
				brackets.close[2],
				brackets.close[2] + 1
			)
		end
	end

	-- set up autocommands
	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		callback = highlight_scope,
		group = vim.api.nvim_create_augroup("ScopeHighlight", { clear = true }),
	})
end

return M


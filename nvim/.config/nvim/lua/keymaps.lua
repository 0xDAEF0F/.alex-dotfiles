-- leader v
-- leader p
-- leader ,
-- leader .
-- leader u
-- leader l
-- leader k

-- Disable search highlighting and close floating windows
vim.keymap.set("n", "<Esc>", function()
	vim.cmd("nohlsearch")
	-- Close any floating windows (including LSP hover)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			-- Check if this is a bottom bar window by looking for the buffer name pattern
			local buf = vim.api.nvim_win_get_buf(win)
			local buf_name = vim.api.nvim_buf_get_name(buf)
			-- Skip closing if it's a bottom bar (empty buffer name and specific window properties)
			if buf_name ~= "" or config.focusable ~= false then
				vim.api.nvim_win_close(win, false)
			end
		end
	end
end)

-- case-sensitive "*"
vim.keymap.set("n", "*", function()
	local word = vim.fn.expand("<cword>")
	vim.fn.setreg("/", "\\C\\<" .. word .. "\\>")
	vim.cmd("normal! n")
end)

-- case-sensitive "#"
vim.keymap.set("n", "#", function()
	local word = vim.fn.expand("<cword>")
	vim.fn.setreg("/", "\\C\\<" .. word .. "\\>")
	vim.cmd("normal! N")
end)

-- Yank without newline
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line without newline" })

-- Yank relative filepath
vim.keymap.set(
	"n",
	"<leader>y",
	"<cmd>let @+ = expand('%')<CR>",
	{ desc = "Yank relative filepath" }
)
-- Yank full directory/file path
vim.keymap.set("n", "<leader>yd", "<cmd>let @+ = expand('%:p:h')<CR>") -- dir
vim.keymap.set("n", "<leader>yf", "<cmd>let @+ = expand('%:p')<CR>") -- file

-- vscode only keymaps
if vim.g.vscode then
	require("keymaps-vscode")
else
	-- map alt+s to save file (in reality its cmd+s, but nvim thinks its alt+s)
	vim.keymap.set("n", "<M-s>", function()
		require("conform").format()
		vim.cmd("w")
	end, { desc = "Save and format with Cmd+S" })
	-- save without formatting
	vim.keymap.set("n", "<leader>s", "<cmd>w<CR>")

	vim.keymap.set("n", "<C-q>", "<cmd>q!<CR>")

	-- change the directory in nvim
	vim.keymap.set("n", "<leader>cd", "<cmd>cd %:h<CR>")

	-- Quickfix navigation
	vim.keymap.set(
		"n",
		"<M-n>",
		"<cmd>cnext<CR>",
		{ desc = "Next quickfix item" }
	)
	vim.keymap.set(
		"n",
		"<M-p>",
		"<cmd>cprev<CR>",
		{ desc = "Previous quickfix item" }
	)

	-- Toggle quickfix
	vim.keymap.set("n", "<leader>cc", function()
		local qf_exists = false
		for _, win in pairs(vim.fn.getwininfo()) do
			if win["quickfix"] == 1 then
				qf_exists = true
				break
			end
		end
		if qf_exists then
			vim.cmd("cclose")
		else
			vim.cmd("copen")
		end
	end, { desc = "Toggle quickfix window" })

	-- Buffer cycling with C-Space
	vim.keymap.set(
		"n",
		"<C-Space>",
		"<cmd>bnext<CR>",
		{ desc = "Next buffer (cycle)" }
	)

	-- Close buffer with C-backspace
	vim.keymap.set("n", "<C-BS>", function()
		local current = vim.api.nvim_get_current_buf()

		-- Get list of normal buffers (excluding nvim-tree and other special buffers)
		local bufs = vim.fn.getbufinfo({ buflisted = 1 })
		local normal_bufs = {}

		for _, buf in ipairs(bufs) do
			local ft = vim.bo[buf.bufnr].filetype
			if ft ~= "NvimTree" and ft ~= "toggleterm" then
				table.insert(normal_bufs, buf.bufnr)
			end
		end

		-- If we have more than one normal buffer, handle switching
		if #normal_bufs > 1 then
			local current_win = vim.api.nvim_get_current_win()

			-- Find current buffer index
			local current_idx = nil

			for i, bufnr in ipairs(normal_bufs) do
				if bufnr == current then
					current_idx = i
					break
				end
			end

			if current_idx then
				-- Get next buffer (wrap around if at the end)
				local next_idx = current_idx < #normal_bufs and current_idx + 1 or 1
				local next_buf = normal_bufs[next_idx]

				-- If next buffer is different from current, switch to it first
				if next_buf ~= current then
					vim.api.nvim_set_current_buf(next_buf)
				end
			end

			-- Delete the original buffer
			vim.cmd("bd " .. current)

			-- Ensure we stay in the current window (not nvim-tree)
			vim.api.nvim_set_current_win(current_win)
		else
			-- Only one buffer, just close it
			vim.cmd("bd")
		end
	end, { desc = "Close buffer" })

	-- Close all buffers except current, NvimTree, and ToggleTerm
	vim.keymap.set("n", "<C-S-BS>", function()
		local current = vim.api.nvim_get_current_buf()
		local protected_bufs = {}

		-- Find NvimTree and ToggleTerm buffers
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
				local ft = vim.api.nvim_buf_get_option(buf, "filetype")
				local name = vim.api.nvim_buf_get_name(buf)

				-- Check if it's NvimTree or ToggleTerm
				if
					ft == "neo-tree"
					or ft == "NvimTree"
					or string.match(name, "term://.*toggleterm")
				then
					table.insert(protected_bufs, buf)
				end
			end
		end

		-- Close all buffers except current and protected buffers
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
				local is_protected = false
				for _, protected_buf in ipairs(protected_bufs) do
					if buf == protected_buf then
						is_protected = true
						break
					end
				end

				if buf ~= current and not is_protected then
					vim.api.nvim_buf_delete(buf, { force = false })
				end
			end
		end
	end, { desc = "Close all buffers except current, NvimTree, and ToggleTerm" })
end

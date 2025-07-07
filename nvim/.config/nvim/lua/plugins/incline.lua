return {
	"b0o/incline.nvim",
	config = function()
		local helpers = require("incline.helpers")
		local devicons = require("nvim-web-devicons")
		require("incline").setup({
			window = {
				padding = 0,
				margin = { horizontal = 0 },
			},
			render = function(props)
				local filename =
					vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				if filename == "" then
					filename = "[No Name]"
				end
				local ft_icon, ft_color = devicons.get_icon_color(filename)
				local modified = vim.bo[props.buf].modified

				-- Remove extension from filename
				local name_without_ext = filename:match("(.+)%..+$") or filename

				-- Get current mode for the window
				local mode = props.focused and vim.fn.mode() or "n"
				local mode_text = ""
				local mode_color = "#393B44"

				if props.focused then
					if mode == "n" then
						mode_text = "N"
						mode_color = "#7FB4CA"
					elseif mode == "i" then
						mode_text = "I"
						mode_color = "#8A9A7B"
					elseif mode == "v" or mode == "V" or mode == "\x16" then
						mode_text = "V"
						mode_color = "#A292A3"
					elseif mode == "R" then
						mode_text = "R"
						mode_color = "#C4746E"
					elseif mode == "c" then
						mode_text = "C"
						mode_color = "#C4B28A"
					elseif mode == "t" then
						mode_text = "T"
						mode_color = "#8EA4A2"
					else
						mode_text = mode:upper():sub(1, 1)
					end
				end

				-- Get git branch
				local git_branch = ""
				local handle = io.popen(
					"git -C "
						.. vim.fn.shellescape(vim.fn.expand("%:p:h"))
						.. " branch --show-current 2>/dev/null"
				)
				if handle then
					git_branch = handle:read("*a"):gsub("\n", "")
					handle:close()
				end

				return {
					-- Mode indicator
					props.focused
							and {
								" ",
								mode_text,
								" ",
								guibg = mode_color,
								guifg = helpers.contrast_color(mode_color),
								gui = "bold",
							}
						or "",
					-- Git branch with separator
					git_branch ~= ""
							and {
								" ",
								{
									"",
									"",
									"",
									"󰊢 ",
									git_branch,
									" ",
									guibg = "#393B44",
									guifg = "#A292A3",
								},
							}
						or "",
					-- File icon
					ft_icon
							and {
								" ",
								ft_icon,
								" ",
								guibg = ft_color,
								guifg = helpers.contrast_color(ft_color),
							}
						or "",
					" ",
					{ name_without_ext, gui = modified and "bold,italic" or "bold" },
					modified and { " [+]", guifg = "#C4746E" } or "",
					" ",
					guibg = "#393B44",
				}
			end,
		})
	end,
	event = "VeryLazy",
	enabled = not vim.g.vscode,
}

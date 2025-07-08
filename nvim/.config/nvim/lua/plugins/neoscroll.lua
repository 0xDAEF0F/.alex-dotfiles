return {
	"karb94/neoscroll.nvim",
	config = function()
		require("neoscroll").setup({
			mappings = {
				"<C-u>",
				"<C-d>",
				"<C-b>",
				"zt",
				"zz",
				"zb",
			},
			hide_cursor = true,
			stop_eof = true,
			respect_scrolloff = false,
			cursor_scrolls_alone = true,
			easing_function = "quadratic",
			pre_hook = nil,
			post_hook = nil,
			performance_mode = false,
		})
	end,
	enabled = not vim.g.vscode,
}

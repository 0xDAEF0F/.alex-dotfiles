return {
	"gbprod/yanky.nvim",
	opts = {
		preserve_cursor_position = {
			enabled = true,
		},
		highlight = {
			on_put = true,
			on_yank = true,
			timer = 200,
		},
	},
	init = function()
		vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
	end,
}

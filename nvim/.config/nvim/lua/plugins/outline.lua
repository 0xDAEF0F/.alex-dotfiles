-- https://github.com/hedyhli/outline.nvim
return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = {
		{ "<leader>e", "<cmd>Outline<CR>", desc = "Toggle outline" },
	},
	opts = {},
}

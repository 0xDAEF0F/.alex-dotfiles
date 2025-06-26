-- https://github.com/numToStr/Comment.nvim
return {
	"numToStr/Comment.nvim",
	opts = {
		toggler = {
			line = "<C-c>",
		},
		opleader = {
			line = "<C-c>",
		},
	},
	enabled = not vim.g.vscode,
}

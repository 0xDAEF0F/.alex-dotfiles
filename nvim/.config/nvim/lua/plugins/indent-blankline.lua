-- https://github.com/lukas-reineke/indent-blankline.nvim
return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	opts = {
		scope = {
			show_start = false, -- disable underline at the start of scope
			show_end = false, -- disable underline at the end of scope
		},
	},
	enabled = not vim.g.vscode,
}

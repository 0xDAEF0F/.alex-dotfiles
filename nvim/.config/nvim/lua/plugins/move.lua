return {
	"fedepujol/move.nvim",
	keys = {
		-- Normal Mode
		{ "<A-j>", ":MoveLine(1)<CR>", desc = "Move Line Up" },
		{ "<A-k>", ":MoveLine(-1)<CR>", desc = "Move Line Down" },
		-- Visual Mode
		{ "<A-j>", ":MoveBlock(1)<CR>", mode = { "v" }, desc = "Move Block Up" },
		{ "<A-k>", ":MoveBlock(-1)<CR>", mode = { "v" }, desc = "Move Block Down" },
	},
	opts = {
		-- Config here
	},
	enabled = not vim.g.vscode,
}

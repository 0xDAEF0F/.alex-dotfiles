return {
	"echasnovski/mini.icons",
	config = function()
		require("mini.icons").setup()
		MiniIcons.tweak_lsp_kind()
	end,
	enabled = not vim.g.vscode,
}

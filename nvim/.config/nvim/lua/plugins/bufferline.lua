-- https://github.com/akinsho/bufferline.nvim
return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				diagnostics = "nvim_lsp",
				name_formatter = function(buf)
					return vim.fn.fnamemodify(buf.name, ":t:r")
				end,
			},
			highlights = {
				buffer_selected = {
					italic = false,
				},
				buffer_visible = {
					italic = false,
				},
				error_selected = {
					italic = false,
				},
				error_diagnostic_selected = {
					italic = false,
				},
				warning_selected = {
					italic = false,
				},
				warning_diagnostic_selected = {
					italic = false,
				},
				info_selected = {
					italic = false,
				},
				info_diagnostic_selected = {
					italic = false,
				},
				hint_selected = {
					italic = false,
				},
				hint_diagnostic_selected = {
					italic = false,
				},
				modified_selected = {
					italic = false,
				},
				duplicate_selected = {
					italic = false,
				},
				pick_selected = {
					italic = false,
				},
			},
		})
	end,
}

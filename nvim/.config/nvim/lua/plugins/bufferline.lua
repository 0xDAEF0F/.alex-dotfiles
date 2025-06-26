-- https://github.com/akinsho/bufferline.nvim
return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(
					count,
					level,
					diagnostics_dict,
					context
				)
					if level == "error" or level == "warning" then
						local icon = level == "error" and " " or " "
						return " " .. icon .. count
					end
					return ""
				end,
			},
		})
	end,
}

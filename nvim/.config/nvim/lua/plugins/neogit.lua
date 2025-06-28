-- https://github.com/NeogitOrg/neogit
return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"ibhagwan/fzf-lua",
	},
	opts = {
		mappings = {
			status = {
				["s"] = false, -- disable it
				["S"] = "Stage",
			},
		},
	},
	init = function()
		vim.keymap.set("n", "<C-S>", function()
			require("neogit").open({ kind = "floating" })
		end)
	end,
}

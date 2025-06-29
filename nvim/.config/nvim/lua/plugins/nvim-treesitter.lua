return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	config = function()
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					node_incremental = "<CR>",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",

						["af"] = "@function.outer",
						["if"] = "@function.inner",

						["ac"] = "@class.outer",
						["ic"] = "@class.inner",

						["ab"] = "@block.outer",
						["ib"] = "@block.inner",

						["as"] = "@statement.outer",
						["is"] = "@statement.outer",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["))"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_previous_start = {
						["(("] = "@function.outer",
						["[["] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		})
	end,
}

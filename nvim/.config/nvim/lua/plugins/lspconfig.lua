return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Configure inlay hint appearance
		vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#888888", italic = true })

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		vim.lsp.config("ts_ls", {
			settings = {
				diagnostics = {
					ignoredCodes = { 6133 }, -- unused variables (biome already warns)
				},
			},
		})

		-- Enable configured servers
		vim.lsp.enable("ts_ls")
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("biome")
		vim.lsp.enable("ruff")
		vim.lsp.enable("tailwindcss")
		vim.lsp.enable("gopls")
		vim.lsp.enable("prismals")

		-- Custom keymaps on LspAttach
		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function(event)
				local opts = { buffer = event.buf }

				-- Additional keymaps beyond defaults
				vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "<leader>o", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, opts)

				-- Toggle inlay hints keybind
				vim.keymap.set("n", "<leader>h", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), nil)
				end)
			end,
		})
	end,
	enabled = not vim.g.vscode,
}

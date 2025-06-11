return {
  -- Main LSP Configuration
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })

    -- Enable configured servers
    vim.lsp.enable("rust_analyzer")
    vim.lsp.enable("ts_ls")
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("biome")
    vim.lsp.enable("ruff")

    -- Custom keymaps on LspAttach
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local opts = { buffer = event.buf }

        -- Additional keymaps beyond defaults
        vim.keymap.set("n", "<leader>A", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>a", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<leader>n", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>o", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, opts)
      end,
    })
  end,
  enabled = not vim.g.vscode,
}

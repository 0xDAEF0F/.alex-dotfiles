return {
  -- Main LSP Configuration
  "neovim/nvim-lspconfig",
  config = function()
    local lsp = require("lspconfig")

    -- VSCode-style LSP keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local opts = { buffer = event.buf }

        -- Go to previous diagnostic
        vim.keymap.set("n", "<leader>A", vim.diagnostic.goto_prev, opts)

        -- Go to next diagnostic
        vim.keymap.set("n", "<leader>a", vim.diagnostic.goto_next, opts)

        -- Go to definition
        vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, opts)

        -- Show hover information
        vim.keymap.set("n", "<leader>n", vim.lsp.buf.hover, opts)

        -- Go to references
        vim.keymap.set("n", "<leader>o", vim.lsp.buf.references, opts)

        -- Rename symbol
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)

        -- Go to implementation
        vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, opts)

        -- Go to type definition
        vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, opts)
      end,
    })

    -- Rust
    lsp.rust_analyzer.setup({})
    -- Typescript
    lsp.ts_ls.setup({})
    -- Lua
    lsp.lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })
  end,
  enabled = not vim.g.vscode,
}

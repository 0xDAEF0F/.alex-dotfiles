return {
  -- Main LSP Configuration
  "neovim/nvim-lspconfig",
  config = function()
    local lsp = require("lspconfig")
    -- Rust
    lsp.rust_analyzer.setup({})
    -- Typescript
    lsp.ts_ls.setup({})
    -- Lua
    lsp.lua_ls.setup({})
  end,
  enabled = not vim.g.vscode,
}

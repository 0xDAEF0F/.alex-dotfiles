return {
  "echasnovski/mini.nvim",
  config = function()
    -- autopairs
    require("mini.pairs").setup()

    require("mini.icons").setup()
    MiniIcons.tweak_lsp_kind()

    -- comments
    require("mini.comment").setup({})
  end,
  enabled = not vim.g.vscode,
}

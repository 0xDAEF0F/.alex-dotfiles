return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  enabled = not vim.g.vscode,
  dependencies = {
    "folke/tokyonight.nvim",
    "rebelot/kanagawa.nvim",
    "EdenEast/nightfox.nvim",
    "sainnhe/everforest",
  },
  config = function()
    vim.cmd([[colorscheme tokyonight]])
  end,
}

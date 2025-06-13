return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  enabled = not vim.g.vscode,
  dependencies = {
    "folke/tokyonight.nvim",
    "rebelot/kanagawa.nvim",
    "EdenEast/nightfox.nvim",
    "neanias/everforest-nvim",
    "morhetz/gruvbox",
    "vague2k/vague.nvim",
    "rose-pine/neovim",
  },
  config = function()
    vim.cmd([[colorscheme vague]])
  end,
}

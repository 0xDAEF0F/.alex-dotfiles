return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  enabled = not vim.g.vscode,
  dependencies = {
    "vague2k/vague.nvim",
    "rebelot/kanagawa.nvim",
    "folke/tokyonight.nvim",
    "EdenEast/nightfox.nvim",
    "neanias/everforest-nvim",
    "sainnhe/gruvbox-material",
    "rose-pine/neovim",
  },
  config = function()
    vim.cmd.colorscheme("nordfox")
  end,
}

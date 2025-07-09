return {
  "vscode-neovim/vscode-multi-cursor.nvim",
  event = "VeryLazy",
  opts = {},
  enabled = not not vim.g.vscode,
}

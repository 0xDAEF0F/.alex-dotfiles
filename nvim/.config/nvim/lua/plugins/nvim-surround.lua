-- https://github.com/kylechui/nvim-surround
return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup()
  end,
  enabled = not vim.g.vscode,
}

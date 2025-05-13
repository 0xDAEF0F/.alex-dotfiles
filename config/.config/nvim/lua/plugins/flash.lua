local labels = "rtneiohysvafumkljcpgdqxbz"
local utils = require("utils")

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    labels = labels,
    label = {
      style = "overlay",
    },
    modes = {
      treesitter = {
        labels = labels,
      },
      char = {
        enabled = false,
      },
    },
    prompt = {
      enabled = false,
    },
  },
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
        if vim.g.vscode then
          utils.centerScreenOnCursor()
          utils.registerJump()
        end
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
  },
}

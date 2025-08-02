-- https://github.com/folke/flash.nvim

local labels = "rtneiohysvafumkljcpgdqxbz"

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    labels = labels,
    highlight = {
      -- extmark priority
      priority = 5000,
    },
    label = {
      style = "overlay",
    },
    modes = {
      treesitter = {
        labels = labels,
        jump = { pos = "range", autojump = false },
        label = { before = true, after = false, style = "inline" },
      },
      char = {
        enabled = true,
        jump_labels = true,
        -- This enables labels during operator-pending mode (c, d, y, etc.)
        config = function(opts)
          -- Don't autohide in operator-pending mode so labels stay visible
          opts.autohide = false
          -- Always show jump labels regardless of mode
          opts.jump_labels = true
        end,
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

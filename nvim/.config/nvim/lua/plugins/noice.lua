return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {},
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        timeout = 700, -- milliseconds
        render = "default",
        stages = "fade_in_slide_out",
      },
    },
  },
  enabled = not vim.g.vscode,
}

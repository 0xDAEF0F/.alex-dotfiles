return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = {
      progress = { enabled = false },
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        timeout = 650, -- milliseconds
        render = "default",
        stages = "fade_in_slide_out",
      },
    },
  },
  enabled = not vim.g.vscode,
}

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "echasnovski/mini.diff",
      config = function()
        local diff = require("mini.diff")
        diff.setup({
          -- Disabled by default
          source = diff.gen_source.none(),
        })
      end,
    },
  },
  init = function()
    vim.keymap.set("v", "<leader>c", ":CodeCompanion ", { desc = "code companion" })
  end,
  opts = {
    adapters = {
      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          name = "openai",
          schema = {
            model = {
              default = "gpt-4o",
            },
          },
        })
      end,
    },
    display = {
      inline = { layout = "vertical" },
    },
    strategies = {
      inline = {
        adapter = "openai",
        keymaps = {
          accept_change = {
            modes = { n = "ga" },
            description = "Accept the suggested change",
          },
          reject_change = {
            modes = { n = "gr" },
            description = "Reject the suggested change",
          },
        },
      },
    },
  },
}

return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    keymaps = {
      ["q"] = { "actions.close", mode = "n" },
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false,
  }
}

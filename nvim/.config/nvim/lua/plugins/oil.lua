return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    keymaps = {
      ["q"] = { "actions.close", mode = "n" },
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
    },
    float = {
      padding = 4,
      max_width = 0.6,
      max_height = 0.6,
    },
    watch_for_changes = true,
    skip_confirm_for_simple_edits = true,
  },
  enabled = not vim.g.vscode,
}

-- https://github.com/stevearc/oil.nvim
-- https://github.com/refractalize/oil-git-status.nvim
return {
  "refractalize/oil-git-status.nvim",
  dependencies = {
    {
      "stevearc/oil.nvim",
      opts = {
        default_file_explorer = true,
        keymaps = {
          ["q"] = { "actions.close", mode = "n" },
        },
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
        win_options = {
          signcolumn = "yes:2",
        },
      },
    },
  },
  lazy = false,
  opts = {},
  -- enabled = not vim.g.vscode,
  enabled = false,
}

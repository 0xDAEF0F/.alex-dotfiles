return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      { "echasnovski/mini.icons", opts = {} },
    },
    enabled = not vim.g.vscode,
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    config = function()
      require("oil").setup({
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
      })
    end,
  },
  {
    "refractalize/oil-git-status.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    },
    config = true,
    enabled = not vim.g.vscode,
  },
}

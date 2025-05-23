return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      rust = { "rustfmt" },
      markdown = { "prettier" },
      json = { "prettier" },
      typescript = { "prettier" },
      lua = { "stylua" },
    },
  },
  enabled = not vim.g.vscode,
}

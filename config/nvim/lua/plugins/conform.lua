return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      rust = { "rustfmt" },
      markdown = { "prettier" },
      typescript = { "prettier" },
      lua = {"stylua"}
    },
  },
}

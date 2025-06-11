return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      rust = { "rustfmt" },
      markdown = { "prettier" },
      json = { "biome" },
      typescript = { "biome" },
      typescriptreact = { "biome" },
      lua = { "stylua" },
      python = { "ruff_format" },
    },
    formatters = {
      ruff_format = {
        command = "ruff",
        args = { "format", "--stdin-filename", "$FILENAME", "-" },
        stdin = true,
      },
    },
  },
  enabled = not vim.g.vscode,
}

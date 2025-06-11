return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      rust = { "rustfmt" },
      markdown = { "prettier" },
      json = { "biome" },
      jsonc = { "biome" },
      typescript = { "biome" },
      typescriptreact = { "biome" },
      lua = { "stylua" },
      python = {
        "ruff_fix",
        "ruff_format",
        "ruff_organize_imports",
      },
      fish = {
        "fish_indent",
      },
    },
  },
  enabled = not vim.g.vscode,
}

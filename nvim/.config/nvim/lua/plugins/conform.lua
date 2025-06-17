return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      rust = { "rustfmt" },
      markdown = { "prettier" },
      json = { "json_sort", "biome" },
      jsonc = { "json_sort", "biome" },
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
    formatters = {
      json_sort = {
        command = "jq",
        args = { "--sort-keys" },
        stdin = true,
      },
    },
  },
  enabled = not vim.g.vscode,
}

return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      rust = { "rustfmt" },
      markdown = { "prettier" },
      json = { "biome" },
      jsonc = { "biome" },
      typescript = { "biome-check" },
      typescriptreact = { "biome-check" },
      -- typescript = { "prettier" },
      -- typescriptreact = { "prettier" },
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
      -- unused
      json_sort = {
        command = "jq",
        args = { "--sort-keys" },
        stdin = true,
      },
      ["biome-check"] = {
        command = "biome",
        args = {
          "check",
          "--write",
          "--unsafe",
          "--stdin-file-path",
          "$FILENAME",
        },
        stdin = true,
      },
    },
  },
  enabled = not vim.g.vscode,
}

return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      rust = { "rustfmt" },
      toml = { "taplo" },
      markdown = { "mdslw", "prettier" },
      json = { "biome" },
      jsonc = { "biome" },
      typescript = { "biome-check", "prettier", stop_after_first = true },
      typescriptreact = { "biome-check", "prettier", stop_after_first = true },
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
      mdslw = { prepend_args = { "--stdin-filepath", "$FILENAME", "--max-width", "90" } },
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

-- https://github.com/Saghen/blink.cmp
-- https://cmp.saghen.dev/
return {
  "saghen/blink.cmp",
  dependencies = {
    { "rafamadriz/friendly-snippets" },
    { "hrsh7th/nvim-cmp" },
    {
      "supermaven-inc/supermaven-nvim",
      opts = {
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-e>",
          accept_word = "<C-n>",
        },
        ignore_filetypes = { cpp = true },
        disable_inline_completion = false,
        disable_keymaps = false,
      },
      enabled = not vim.g.vscode,
    },
    {
      "huijiro/blink-cmp-supermaven",
    },
    {
      "mikavilpas/blink-ripgrep.nvim",
    },
  },
  version = "1.*",
  opts = {
    keymap = {
      ["<CR>"] = { "accept", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<C-c>"] = { "hide", "fallback" },
      ["<Esc>"] = { "hide", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    },

    appearance = {
      nerd_font_variant = "mono",
    },

    -- documentation popup
    completion = {
      documentation = { auto_show = true },
      list = {
        selection = {
          auto_insert = false,
        },
      },
    },

    sources = {
      -- default = { "lsp", "path", "supermaven", "buffer", "ripgrep", "snippets" },
      default = { "lsp", "path", "buffer", "ripgrep", "snippets" },
      providers = {
        supermaven = {
          name = "supermaven",
          module = "blink-cmp-supermaven",
          async = true,
        },
        ripgrep = {
          name = "Ripgrep",
          module = "blink-ripgrep",
          opts = {
            prefix_min_len = 3,
            context_size = 5,
            max_filesize = "1M",
          },
        },
      },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
  enabled = not vim.g.vscode,
}

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
        disable_inline_completion = true, -- disables inline completion for use with cmp
        disable_keymaps = true, -- disables built in keymaps for more manual control
      },
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
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = "super-tab",
      ["<CR>"] = { "accept", "fallback" },
      ["<M-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-c>"] = { "hide", "fallback" },
    },

    appearance = {
      nerd_font_variant = "mono",
    },

    -- documentation popup
    completion = { documentation = { auto_show = true } },

    sources = {
      default = { "lsp", "path", "supermaven", "buffer", "ripgrep", "snippets" },
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

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
  },
  version = "1.*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = "enter" },

    appearance = {
      nerd_font_variant = "mono",
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = true } },

    sources = {
      default = { "lsp", "path", "supermaven", "snippets" },
      providers = {
        supermaven = {
          name = "supermaven",
          module = "blink-cmp-supermaven",
          async = true,
        },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
  enabled = not vim.g.vscode,
}

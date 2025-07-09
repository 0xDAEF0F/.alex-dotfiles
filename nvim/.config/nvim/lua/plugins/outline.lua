-- https://github.com/hedyhli/outline.nvim
return {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = {
    { "<leader>e", "<cmd>Outline<CR>", desc = "Toggle outline" },
  },
  opts = {
    preview_window = {
      live = false,
    },
    outline_window = {
      width = 17,
      show_numbers = false,
      show_relative_numbers = false,
      show_cursorline = true,
      focus_on_open = false,
      auto_close = false,
    },
    outline_items = {
      show_symbol_details = false,
    },
    symbol_folding = {
      markers = { "", "" },
    },
  },
}

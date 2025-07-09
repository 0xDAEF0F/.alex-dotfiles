-- https://github.com/otavioschwanck/arrow.nvim
return {
  "otavioschwanck/arrow.nvim",
  dependencies = {
    { "echasnovski/mini.icons" },
  },
  opts = {
    show_icons = true,
    leader_key = ";", -- Recommended to be a single key
    buffer_leader_key = "m", -- Per Buffer Mappings
    mappings = {
      next_item = ")",
      prev_item = "(",
    },
  },
}

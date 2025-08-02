return {
  -- "dmtrKovalenko/fff.nvim",
  -- build = "cargo build --release",
  dir = "/Users/ale/mimi/erepos/fff.nvim",
  name = "fff.nvim",
  opts = {
    debug = {
      show_scores = true,
    },
  },
  keys = {
    {
      "<C-p>",
      function()
        require("fff").toggle()
      end,
      desc = "Toggle FFF",
    },
  },
}

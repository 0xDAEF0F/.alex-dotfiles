return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release",
  opts = {},
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

return {
  {
    "diogo464/hotreload.nvim",
    opts = {
      interval = 400,
    },
    {
      {
        "Zeioth/hot-reload.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        event = "BufEnter",
        opts = {},
      },
    },
  },
}

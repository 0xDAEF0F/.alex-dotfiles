return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    keywords = {
      TODO = { icon = " ", color = "info", alt = { "todo" } },
    },
    colors = {
      info = { "DiagnosticInfo", "#2563EB" },
    },
  },
}

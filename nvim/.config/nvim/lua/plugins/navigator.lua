return {
  "numToStr/Navigator.nvim",
  config = function()
    vim.keymap.set({ "n", "t" }, "<A-h>", "<CMD>NavigatorLeft<CR>")
    vim.keymap.set({ "n", "t" }, "<A-i>", "<CMD>NavigatorRight<CR>")
    vim.keymap.set({ "n", "t" }, "<A-e>", "<CMD>NavigatorUp<CR>")
    vim.keymap.set({ "n", "t" }, "<A-n>", "<CMD>NavigatorDown<CR>")
    require("Navigator").setup()
  end,
}

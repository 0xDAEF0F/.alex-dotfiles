return {
  "ojroques/nvim-bufdel",
  init = function()
    vim.keymap.set("n", "<BS>", "<cmd>BufDel!<CR>", { desc = "Close buffer" })
    vim.keymap.set("n", "<C-BS>", "<cmd>BufDelOthers<CR>", { desc = "Close all buffers except current" })
  end,
}

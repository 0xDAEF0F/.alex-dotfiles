-- https://github.com/lewis6991/gitsigns.nvim
return {
  "lewis6991/gitsigns.nvim",
  opts = {},
  init = function()
    vim.keymap.set("n", "<leader>f", "<cmd>lua require('gitsigns').stage_hunk()<CR>")
    vim.keymap.set("n", "<leader><leader>", "<cmd>lua require('gitsigns').preview_hunk()<CR>")
    vim.keymap.set("n", "}}", "<cmd>lua require('gitsigns').nav_hunk('next')<CR>")
    vim.keymap.set("n", "{{", "<cmd>lua require('gitsigns').nav_hunk('prev')<CR>")
  end,
}

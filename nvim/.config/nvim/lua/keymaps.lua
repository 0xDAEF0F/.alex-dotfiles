-- Disable search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Case-sensitive * and # search
vim.keymap.set("n", "*", function()
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg("/", "\\C\\<" .. word .. "\\>")
  vim.cmd("normal! n")
end, { desc = "Case-sensitive forward word search" })

vim.keymap.set("n", "#", function()
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg("/", "\\C\\<" .. word .. "\\>")
  vim.cmd("normal! N")
end, { desc = "Case-sensitive backward word search" })

-- Yank without newline
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line without newline" })

-- Yank full directory/file path
vim.keymap.set("n", "<leader>yd", ":let @+ = expand('%:p:h')<CR>") -- dir
vim.keymap.set("n", "<leader>yf", ":let @+ = expand('%:p')<CR>") -- file

-- vscode only keymaps
if vim.g.vscode then
  require("keymaps-vscode")
else
  -- normal vim keymaps
  vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
  vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")
  vim.keymap.set("n", "-", "<cmd>Oil --float<CR>")
  vim.keymap.set("n", "<leader>f", "<cmd>lua require('conform').format()<CR>")
  vim.keymap.set("n", "<leader>cd", "<cmd>cd%:h<CR>")
end

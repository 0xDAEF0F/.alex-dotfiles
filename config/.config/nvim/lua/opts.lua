vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.scrolloff = 0
vim.o.timeoutlen = 400

if vim.g.vscode then
  -- vscode only options
else
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.signcolumn = "yes"
  vim.opt.mouse = "a"
  vim.opt.showmode = false
  vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
  vim.opt.completeopt = "menuone,noinsert"

  vim.opt.splitright = true
  vim.opt.splitbelow = true
end

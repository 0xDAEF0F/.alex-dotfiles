vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.timeoutlen = 400

if vim.g.vscode then
  vim.o.scrolloff = 0
  -- vscode only options
else
  vim.opt.tabstop = 3 -- display 3 spaces per tab
  vim.o.scrolloff = 10

  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.signcolumn = "yes"
  vim.opt.mouse = "a"
  vim.opt.showmode = false
  vim.opt.completeopt = "menuone,noinsert"

  vim.opt.splitright = true
  vim.opt.splitbelow = true
end

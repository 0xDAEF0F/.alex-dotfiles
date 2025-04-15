vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.completeopt = "menuone,noinsert"

vim.opt.splitright = true
vim.opt.splitbelow = true

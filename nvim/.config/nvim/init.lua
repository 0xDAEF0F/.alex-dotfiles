vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("opts")
require("keymaps")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup(
    "kickstart-highlight-yank",
    { clear = true }
  ),
  callback = function()
    vim.highlight.on_yank()
  end,
})

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
})

-- Stop automatic comment continuation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  desc = "Stop automatic comment continuation",
  callback = function()
    -- remove the 'c', 'r', and 'o' flags from 'formatoptions'
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

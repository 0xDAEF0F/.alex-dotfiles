vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out =
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("opts")
require("keymaps")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

if vim.g.vscode then
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      require("vscode").call("workbench.action.files.saveWithoutFormatting")
    end,
  })
end

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
})

-- OLD CONFIG
-- -- vscode_utils.lua
-- function call(arg)
--   nvim_feedkeys(string.format(":call %s<enter>", arg))
-- end

-- -- register a jump after insert mode is left
-- vim.keymap.set({ "i" }, "<escape>", function()
--   nvim_feedkeys("<escape>")
--   register_jump()
-- end)

-- -- register a jump whenever a forward search is started
-- vim.keymap.set({ "n" }, "/", function()
--   register_jump()
--   nvim_feedkeys("/")
-- end)

-- -- Go to previous problem in file
-- vim.keymap.set(
--   "n",
--   "<leader>a",
--   ":lua require('vscode').call('editor.action.marker.prev')<CR>",
--   { silent = true }
-- )

-- -- Go next problem in file
-- vim.keymap.set(
--   "n",
--   "<leader>d",
--   ":lua require('vscode').call('editor.action.marker.next')<CR>",
--   { silent = true }
-- )

-- -- Go to next git change
-- vim.keymap.set(
--   "n",
--   "<leader>n",
--   ":lua require('vscode').call('workbench.action.editor.nextChange')<CR>",
--   { silent = true }
-- )

-- -- multicursor like in vscode
-- vim.keymap.set("n", "<C-z>", "mciw*<Cmd>nohl<CR>", { remap = true })

-- vim.keymap.set("n", "n", function()
--   local success, _ = pcall(vim.cmd, "normal! n")

--   if not success then
--     return
--   end

--   centerScreenOnCursor()
--   register_jump()
-- end, { noremap = true, silent = true })

-- vim.keymap.set("n", "N", function()
--   local success, _ = pcall(vim.cmd, "normal! N")

--   if not success then
--     return
--   end

--   centerScreenOnCursor()
--   register_jump()
-- end, { noremap = true, silent = true })

-- vim.keymap.set("n", "*", function()
--   local success, _ = pcall(vim.cmd, "normal! *")

--   if not success then
--     return
--   end

--   centerScreenOnCursor()
--   register_jump()
-- end, { noremap = true, silent = true })

-- vim.keymap.set("n", "#", function()
--   local success, _ = pcall(vim.cmd, "normal! #")

--   if not success then
--     return
--   end

--   centerScreenOnCursor()
--   register_jump()
-- end, { noremap = true, silent = true })

-- -- Centers the cursor after you search with / or ?
-- vim.keymap.set("c", "<CR>", function()
--   local cmdtype = vim.fn.getcmdtype()
--   if cmdtype == "/" or cmdtype == "?" then
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
--     centerScreenOnCursor()
--     register_jump()
--     return ""
--   end
--   return "<CR>"
-- end, { expr = true })

-- -- Redraws the screen after text changes because it is buggy
-- vim.api.nvim_create_autocmd("TextChanged", {
--   pattern = "*",
--   callback = function()
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "n", false)
--   end,
-- })

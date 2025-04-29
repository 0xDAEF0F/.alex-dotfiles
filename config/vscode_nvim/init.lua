-- vscode_utils.lua
function nvim_feedkeys(keys)
  local feedable_keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(feedable_keys, "n", false)
end

function call(arg)
  nvim_feedkeys(string.format(":call %s<enter>", arg))
end

-- register a jump after insert mode is left
vim.keymap.set({ "i" }, "<escape>", function()
  nvim_feedkeys("<escape>")
  register_jump()
end)

-- register a jump whenever a forward search is started
vim.keymap.set({ "n" }, "/", function()
  register_jump()
  nvim_feedkeys("/")
end)

-- Toggle highlight search for empty lines
vim.keymap.set("n", "<leader><leader>", function()
  require("flash").jump({
    search = {
      mode = "search",
    },
    pattern = "^$",
    label = {
      after = { 0, 0 },
    },
  })
  centerScreenOnCursor()
end)

-- Go to previous problem in file
vim.keymap.set(
  "n",
  "<leader>a",
  ":lua require('vscode').call('editor.action.marker.prev')<CR>",
  { silent = true }
)

-- Go next problem in file
vim.keymap.set(
  "n",
  "<leader>d",
  ":lua require('vscode').call('editor.action.marker.next')<CR>",
  { silent = true }
)

-- Go to next git change
vim.keymap.set(
  "n",
  "<leader>n",
  ":lua require('vscode').call('workbench.action.editor.nextChange')<CR>",
  { silent = true }
)

-- multicursor like in vscode
vim.keymap.set("n", "<C-z>", "mciw*<Cmd>nohl<CR>", { remap = true })

-- Rename symbol
vim.keymap.set(
  "n",
  "gR",
  ":lua require('vscode').call('editor.action.rename')<CR>",
  { silent = true }
)

vim.keymap.set("n", "n", function()
  local success, _ = pcall(vim.cmd, "normal! n")

  if not success then
    return
  end

  centerScreenOnCursor()
  register_jump()
end, { noremap = true, silent = true })

vim.keymap.set("n", "N", function()
  local success, _ = pcall(vim.cmd, "normal! N")

  if not success then
    return
  end

  centerScreenOnCursor()
  register_jump()
end, { noremap = true, silent = true })

vim.keymap.set("n", "*", function()
  local success, _ = pcall(vim.cmd, "normal! *")

  if not success then
    return
  end

  centerScreenOnCursor()
  register_jump()
end, { noremap = true, silent = true })

vim.keymap.set("n", "#", function()
  local success, _ = pcall(vim.cmd, "normal! #")

  if not success then
    return
  end

  centerScreenOnCursor()
  register_jump()
end, { noremap = true, silent = true })

-- Centers the cursor after you search with / or ?
vim.keymap.set("c", "<CR>", function()
  local cmdtype = vim.fn.getcmdtype()
  if cmdtype == "/" or cmdtype == "?" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
    centerScreenOnCursor()
    register_jump()
    return ""
  end
  return "<CR>"
end, { expr = true })

-- Redraws the screen after text changes because it is buggy
vim.api.nvim_create_autocmd("TextChanged", {
  pattern = "*",
  callback = function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "n", false)
  end,
})

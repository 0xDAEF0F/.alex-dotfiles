local utils = require("utils")

-- format
vim.keymap.set("n", "<leader>f", function()
  require("vscode").call("editor.action.format")
end)

-- Toggle ai completions
vim.keymap.set("n", "<leader>g", function()
  require("vscode").call("editor.cpp.toggle")
end)

-- Toggle statusbar
vim.keymap.set("n", "<leader>p", function()
  local vscode = require("vscode")
  vscode.call("workbench.action.toggleStatusbarVisibility")
end)

-- Bookmarks functionality
vim.api.nvim_set_keymap(
  "n",
  "<leader>b",
  ":lua require('vscode').call('bookmarks.toggle')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>r",
  ":lua require('vscode').call('bookmarks.jumpToNext')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>a",
  ":lua require('vscode').call('bookmarks.jumpToPrevious')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>l",
  ":lua require('vscode').call('bookmarks.listFromAllFiles')<CR>",
  { noremap = true, silent = true }
)

-- LSP FUNCTIONALITY

-- Go to definition
vim.keymap.set({ "n" }, "<leader>d", function()
  utils.registerJump()
  require("vscode").call("editor.action.revealDefinition")
end)

-- Go to hover
vim.keymap.set({ "n" }, "<leader>n", function()
  local vscode = require("vscode")
  vscode.call("editor.action.showHover")
end)

-- Go to references
vim.keymap.set({ "n" }, "<leader>o", function()
  utils.registerJump()
  require("vscode").call("editor.action.goToReferences")
end)

-- Rename symbol
vim.keymap.set(
  "n",
  "<leader>r",
  ":lua require('vscode').call('editor.action.rename')<CR>",
  { silent = true }
)

-- Go to implementation
vim.keymap.set({ "n" }, "<leader>i", function()
  utils.registerJump()
  require("vscode").call("editor.action.goToImplementation")
end)

-- Go to type definition
vim.keymap.set({ "n" }, "<leader>t", function()
  utils.registerJump()
  require("vscode").call("editor.action.goToTypeDefinition")
end)

-- Comment line
vim.keymap.set(
  { "n", "v" },
  "<leader>c",
  ":lua require('vscode').call('editor.action.commentLine')<CR>",
  { silent = true }
)

vim.keymap.set({ "n" }, "<c-o>", function()
  require("vscode").call("jumplist.jumpBack", { args = { 1 } })
end, { noremap = true })

vim.keymap.set({ "n" }, "<c-i>", function()
  require("vscode").call("jumplist.jumpForward", { args = { 1 } })
end, { noremap = true })

-- SCROLL UP/DOWN

vim.keymap.set({ "n", "x" }, "<C-u>", function()
  local visibleRanges =
    require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
  local height = visibleRanges[1][2].line - visibleRanges[1][1].line
  for i = 1, height / 3 do
    vim.api.nvim_feedkeys("k", "n", false)
  end
  utils.centerScreenOnCursor()
  utils.registerJump()
end)

vim.keymap.set({ "n", "x" }, "<C-d>", function()
  local visibleRanges =
    require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
  local height = visibleRanges[1][2].line - visibleRanges[1][1].line
  for i = 1, height / 3 do
    vim.api.nvim_feedkeys("j", "n", false)
  end
  utils.centerScreenOnCursor()
  utils.registerJump()
end)

vim.keymap.set({ "n", "x" }, "<C-f>", function()
  local visibleRanges =
    require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
  local height = visibleRanges[1][2].line - visibleRanges[1][1].line
  for i = 1, height / 2 do
    vim.api.nvim_feedkeys("j", "n", false)
  end
  utils.centerScreenOnCursor()
  utils.registerJump()
end)

vim.keymap.set({ "n", "x" }, "<C-b>", function()
  local visibleRanges =
    require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
  local height = visibleRanges[1][2].line - visibleRanges[1][1].line
  for i = 1, height / 2 do
    vim.api.nvim_feedkeys("k", "n", false)
  end
  utils.centerScreenOnCursor()
  utils.registerJump()
end)

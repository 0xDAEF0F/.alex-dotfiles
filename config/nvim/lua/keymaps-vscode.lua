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
vim.keymap.set("n", "<leader>b", function()
  local vscode = require("vscode")
  vscode.call("workbench.action.toggleStatusbarVisibility")
end)

-- Bookmarks functionality
vim.api.nvim_set_keymap(
  "n",
  "<leader>t",
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

-- Go to hover
vim.keymap.set({ "n" }, "gh", function()
  local vscode = require("vscode")
  vscode.call("editor.action.showHover")
end)

-- Go to type definition
vim.keymap.set({ "n" }, "gD", function()
  utils.registerJump()
  require("vscode").call("editor.action.goToTypeDefinition")
end)

-- Go to definition
vim.keymap.set({ "n" }, "gd", function()
  utils.registerJump()
  require("vscode").call("editor.action.revealDefinition")
end)

-- Go to implementation
vim.keymap.set({ "n" }, "gi", function()
  utils.registerJump()
  require("vscode").call("editor.action.goToImplementation")
end)

-- Go to references (buggy)
vim.keymap.set({ "n" }, "gr", function()
  utils.registerJump()
  require("vscode").call("editor.action.goToReferences")
end)

-- Comment line
vim.keymap.set(
  { "n", "v" },
  "<leader>c",
  ":lua require('vscode').call('editor.action.commentLine')<CR>",
  { silent = true }
)

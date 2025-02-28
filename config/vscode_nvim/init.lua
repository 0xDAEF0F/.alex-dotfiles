-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "rtneiohysvafumkljcpgdqxbz",
      action = function(match, state)
        require("flash.jump").jump(match, state)
        require("flash.jump").on_jump(state)
        -- Centers the screen on the current line
        require("vscode").eval_async([[
          const editor = vscode.window.activeTextEditor;
          if (editor) {
            const position = editor.selection.active;
            const range = new vscode.Range(position, position);
            editor.revealRange(range, vscode.TextEditorRevealType.InCenter);
          }
        ]])
      end,
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      -- This is not working
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
  },
  { "tenxsoydev/karen-yank.nvim", config = true },
}, {})

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.scrolloff = 0
vim.o.timeoutlen = 500

-- Toggle highlight search
-- vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- (interfering with leap)
vim.keymap.set("n", "<leader>j", ":nohlsearch<CR>", { silent = true })

-- Rename symbol
vim.keymap.set(
  "n",
  "gR",
  ":lua require('vscode').call('editor.action.rename')<CR>",
  { silent = true }
)
-- Go to references
vim.keymap.set(
  "n",
  "gr",
  ":lua require('vscode').call('editor.action.goToReferences')<CR>",
  { silent = true }
)
-- Comment line
vim.keymap.set(
  { "n", "v" },
  "<leader>c",
  ":lua require('vscode').call('editor.action.commentLine')<CR>",
  { silent = true }
)

-- Search with periscope
vim.api.nvim_set_keymap(
  "n",
  "<leader>f",
  ":lua require('vscode').call('periscope.search')<CR>",
  { noremap = true, silent = true }
)

-- Bookmarks functionality
vim.api.nvim_set_keymap(
  "n",
  "<leader>m",
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
  "<leader>h",
  ":lua require('vscode').call('bookmarks.listFromAllFiles')<CR>",
  { noremap = true, silent = true }
)

-- Toggle ai completions
vim.api.nvim_set_keymap(
  "n",
  "<leader>g",
  ":lua ToggleInlineSuggestionsAndNotify()<CR>",
  { noremap = true, silent = true }
)

function ToggleInlineSuggestionsAndNotify()
  local vscode = require("vscode")
  local hadAutocompletion = vscode.get_config("github.copilot.editor.enableAutoCompletions")
  vscode.call("multiCommand.toggleInlineSuggestions")
  vscode.notify("Inline suggestions " .. (hadAutocompletion and "disabled!" or "enabled!"))
end

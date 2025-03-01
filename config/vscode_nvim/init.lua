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
  {
    "vscode-neovim/vscode-multi-cursor.nvim",
    event = "VeryLazy",
    cond = not not vim.g.vscode,
    opts = {},
  },
}, {})

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.scrolloff = 0
vim.o.timeoutlen = 500

-- Toggle highlight search
-- vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- (interfering with leap)
vim.keymap.set("n", "<leader>j", ":nohlsearch<CR>", { silent = true })

-- multicursor like in vscode
vim.keymap.set("n", "<C-z>", "mciw*<Cmd>nohl<CR>", { remap = true })

-- `ci"` can now be done with `ciq`
vim.keymap.set("x", "iq", [[:<C-u>normal! T"vt"<CR>]], { noremap = true, silent = true })
vim.keymap.set("o", "iq", ':normal vi"<CR>', { noremap = true, silent = true })

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

vim.keymap.set({ "n" }, "gD", function()
  require("vscode").call("editor.action.goToTypeDefinition")
end)

function ToggleInlineSuggestionsAndNotify()
  local vscode = require("vscode")
  local hadAutocompletion = vscode.get_config("github.copilot.editor.enableAutoCompletions")
  vscode.call("multiCommand.toggleInlineSuggestions")
  vscode.notify("Inline suggestions " .. (hadAutocompletion and "disabled!" or "enabled!"))
end

vim.keymap.set({ "n", "x" }, "<C-u>", function()
  local visibleRanges =
    require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
  local height = visibleRanges[1][2].line - visibleRanges[1][1].line
  for i = 1, height / 4 do
    vim.api.nvim_feedkeys("k", "n", false)
  end
  require("vscode").action("neovim-ui-indicator.cursorCenter")
end)

vim.keymap.set({ "n", "x" }, "<C-d>", function()
  local visibleRanges =
    require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
  local height = visibleRanges[1][2].line - visibleRanges[1][1].line
  for i = 1, height / 4 do
    vim.api.nvim_feedkeys("j", "n", false)
  end
  require("vscode").action("neovim-ui-indicator.cursorCenter")
end)

vim.keymap.set({ "n", "x" }, "<C-f>", function()
  local visibleRanges =
    require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
  local height = visibleRanges[1][2].line - visibleRanges[1][1].line
  for i = 1, height / 2 do
    vim.api.nvim_feedkeys("j", "n", false)
  end
  require("vscode").action("neovim-ui-indicator.cursorCenter")
end)

vim.keymap.set({ "n", "x" }, "<C-b>", function()
  local visibleRanges =
    require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
  local height = visibleRanges[1][2].line - visibleRanges[1][1].line
  for i = 1, height / 2 do
    vim.api.nvim_feedkeys("k", "n", false)
  end
  require("vscode").action("neovim-ui-indicator.cursorCenter")
end)

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == "i" then
      require("vscode").action("neovim-ui-indicator.insert")
    elseif mode == "v" then
      require("vscode").action("neovim-ui-indicator.visual")
    elseif mode == "n" then
      require("vscode").action("neovim-ui-indicator.normal")
    end
  end,
})

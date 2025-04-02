vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- vscode_utils.lua
function nvim_feedkeys(keys)
  local feedable_keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(feedable_keys, "n", false)
end

function call(arg)
  nvim_feedkeys(string.format(":call %s<enter>", arg))
end

function register_jump()
  -- we are using jumplist number 1 instead of the default so that we can
  -- control all of our jumplist positions.
  require("vscode").call("jumplist.registerJump", { args = { 1 } })
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

vim.keymap.set({ "n" }, "<c-o>", function()
  require("vscode").call("jumplist.jumpBack", { args = { 1 } })
end, { noremap = true })

vim.keymap.set({ "n" }, "<c-i>", function()
  require("vscode").call("jumplist.jumpForward", { args = { 1 } })
end, { noremap = true })

-- Just a little helper function to center the cursor on the screen
local centerScreenOnCursor = function()
  require("vscode").eval_async([[
    const editor = vscode.window.activeTextEditor;
    if (editor) {
      const cursorPosition = editor.selection.active;
      const range = new vscode.Range(cursorPosition, cursorPosition);
      editor.revealRange(range, vscode.TextEditorRevealType.InCenter);
    }
  ]])
end

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
    -- Highlight other instances of the word under the cursor
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function()
      require("illuminate").configure({
        min_count_to_highlight = 2,
      })
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "rtneiohysvafumkljcpgdqxbz",
      label = {
        style = "overlay",
      },
      modes = {
        treesitter = {
          labels = "rtneiohysvafumkljcpgdqxbz",
        },
        char = {
          enabled = false,
        },
      },
      prompt = {
        enabled = false,
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
          centerScreenOnCursor()
          register_jump()
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

require("nvim-treesitter.configs").setup({
  auto_install = true,
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-x>",
      node_incremental = "<c-x>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",

        ["af"] = "@function.outer",
        ["if"] = "@function.inner",

        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",

        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",

        ["as"] = "@statement.outer",
        ["is"] = "@statement.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["))"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_previous_start = {
        ["(("] = "@function.outer",
        ["[["] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
})

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.scrolloff = 0
vim.o.timeoutlen = 500

-- Yank full directory/file path
vim.keymap.set("n", "<leader>yd", ":let @+ = expand('%:p:h')<CR>") -- dir
vim.keymap.set("n", "<leader>yf", ":let @+ = expand('%:p')<CR>") -- file

-- Toggle highlight search
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { silent = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

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

-- LSP FUNCTIONALITY
-- Go to hover
vim.keymap.set({ "n" }, "gh", function()
  local vscode = require("vscode")
  vscode.call("editor.action.showHover")
end)

-- Go to type definition
vim.keymap.set({ "n" }, "gD", function()
  register_jump()
  require("vscode").call("editor.action.goToTypeDefinition")
end)

-- Go to definition
vim.keymap.set({ "n" }, "gd", function()
  register_jump()
  require("vscode").call("editor.action.revealDefinition")
end)

-- Go to implementation
vim.keymap.set({ "n" }, "gi", function()
  register_jump()
  require("vscode").call("editor.action.goToImplementation")
end)

-- Go to references (buggy)
vim.keymap.set({ "n" }, "gr", function()
  register_jump()
  require("vscode").call("editor.action.goToReferences")
end)
-- END LSP FUNCTIONALITY

-- Comment line
vim.keymap.set(
  { "n", "v" },
  "<leader>c",
  ":lua require('vscode').call('editor.action.commentLine')<CR>",
  { silent = true }
)

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

-- Toggle ai completions
vim.api.nvim_set_keymap(
  "n",
  "<leader>g",
  ":lua ToggleInlineSuggestionsAndNotify()<CR>",
  { noremap = true, silent = true }
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

function ToggleInlineSuggestionsAndNotify()
  local vscode = require("vscode")
  local hadAutocompletion = vscode.get_config("github.copilot.editor.enableAutoCompletions")
  vscode.call("multiCommand.toggleInlineSuggestions")
  vscode.notify("Inline suggestions " .. (hadAutocompletion and "disabled!" or "enabled!"))
end

-- SCROLL UP/DOWN
vim.keymap.set({ "n", "x" }, "<C-u>", function()
  local visibleRanges =
    require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
  local height = visibleRanges[1][2].line - visibleRanges[1][1].line
  for i = 1, height / 3 do
    vim.api.nvim_feedkeys("k", "n", false)
  end
  centerScreenOnCursor()
  register_jump()
end)

vim.keymap.set({ "n", "x" }, "<C-d>", function()
  local visibleRanges =
    require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
  local height = visibleRanges[1][2].line - visibleRanges[1][1].line
  for i = 1, height / 3 do
    vim.api.nvim_feedkeys("j", "n", false)
  end
  centerScreenOnCursor()
  register_jump()
end)

vim.keymap.set({ "n", "x" }, "<C-f>", function()
  local visibleRanges =
    require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
  local height = visibleRanges[1][2].line - visibleRanges[1][1].line
  for i = 1, height / 2 do
    vim.api.nvim_feedkeys("j", "n", false)
  end
  centerScreenOnCursor()
  register_jump()
end)

vim.keymap.set({ "n", "x" }, "<C-b>", function()
  local visibleRanges =
    require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
  local height = visibleRanges[1][2].line - visibleRanges[1][1].line
  for i = 1, height / 2 do
    vim.api.nvim_feedkeys("k", "n", false)
  end
  centerScreenOnCursor()
  register_jump()
end)
-- END SCROLL UP/DOWN

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

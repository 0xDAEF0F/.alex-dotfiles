-- leader v
-- leader p
-- leader ,
-- leader .
-- leader u
-- leader l
-- leader k

-- Disable search highlighting and close floating windows
vim.keymap.set("n", "<Esc>", function()
  vim.cmd("nohlsearch")
  -- Close any floating windows (including LSP hover)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      -- Check if this is a bottom bar window by looking for the buffer name pattern
      local buf = vim.api.nvim_win_get_buf(win)
      local buf_name = vim.api.nvim_buf_get_name(buf)
      -- Skip closing if it's a bottom bar (empty buffer name and specific window properties)
      if buf_name ~= "" or config.focusable ~= false then
        vim.api.nvim_win_close(win, false)
      end
    end
  end
end)

-- case-sensitive "*"
vim.keymap.set("n", "*", function()
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg("/", "\\C\\<" .. word .. "\\>")
  vim.cmd("normal! nzz")
end)

-- case-sensitive "#"
vim.keymap.set("n", "#", function()
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg("/", "\\C\\<" .. word .. "\\>")
  vim.cmd("normal! Nzz")
end)

-- Yank without newline
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line without newline" })

-- Yank relative filepath
vim.keymap.set("n", "<leader>y", "<cmd>let @+ = expand('%')<CR>", { desc = "Yank relative filepath" })
-- Yank full directory/file path
vim.keymap.set("n", "<leader>yd", "<cmd>let @+ = expand('%:p:h')<CR>") -- dir
vim.keymap.set("n", "<leader>yf", "<cmd>let @+ = expand('%:p')<CR>") -- file

-- vscode only keymaps
if vim.g.vscode then
  require("keymaps-vscode")
else
  -- map alt+s to save file (in reality its cmd+s, but nvim thinks its alt+s)
  vim.keymap.set("n", "<M-s>", function()
    require("conform").format({
      lsp_format = "fallback",
      timeout_ms = 500,
    })
    vim.cmd("w")
  end, { desc = "Save and format with Cmd+S" })
  -- save without formatting
  vim.keymap.set("n", "<leader>s", "<cmd>w<CR>")

  vim.keymap.set("n", "<C-q>", function()
    vim.cmd("Neotree close")
    vim.cmd("q!")
  end)

  -- change the directory in nvim
  vim.keymap.set("n", "<leader>cd", "<cmd>cd %:h<CR>")

  -- Quickfix navigation
  vim.keymap.set("n", "<M-n>", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
  vim.keymap.set("n", "<M-p>", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })

  -- Toggle quickfix
  vim.keymap.set("n", "<leader>cc", function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
      if win["quickfix"] == 1 then
        qf_exists = true
        break
      end
    end
    if qf_exists then
      vim.cmd("cclose")
    else
      vim.cmd("copen")
    end
  end, { desc = "Toggle quickfix window" })

  -- Buffer cycling with C-Space
  vim.keymap.set("n", "<C-Space>", "<cmd>bnext<CR>", { desc = "Next buffer (cycle)" })
end

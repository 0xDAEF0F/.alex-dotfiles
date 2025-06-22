-- Disable search highlighting and close floating windows
vim.keymap.set("n", "<Esc>", function()
  vim.cmd("nohlsearch")
  -- Close any floating windows (including LSP hover)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end)

-- case-sensitive "*"
vim.keymap.set("n", "*", function()
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg("/", "\\C\\<" .. word .. "\\>")
  vim.cmd("normal! n")
end)

-- case-sensitive "#"
vim.keymap.set("n", "#", function()
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg("/", "\\C\\<" .. word .. "\\>")
  vim.cmd("normal! N")
end)

-- Yank without newline
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line without newline" })

-- Yank full directory/file path
vim.keymap.set("n", "<leader>yd", ":let @+ = expand('%:p:h')<CR>") -- dir
vim.keymap.set("n", "<leader>yf", ":let @+ = expand('%:p')<CR>") -- file

-- vscode only keymaps
if vim.g.vscode then
  require("keymaps-vscode")
else
  -- Map alt+s to save file (in reality its cmd+s, but nvim thinks its alt+s)
  vim.keymap.set("n", "<M-s>", function()
    require("conform").format()
    vim.cmd("w")
  end, { desc = "Save and format with Cmd+S" })

  vim.keymap.set("n", "<C-q>", "<cmd>q!<CR>")
  vim.keymap.set("n", "-", "<cmd>Oil --float<CR>")
  vim.keymap.set("n", "<leader>f", "<cmd>lua require('conform').format()<CR>")

  -- change the directory in nvim
  vim.keymap.set("n", "<leader>cd", "<cmd>cd%:h<CR>")

  -- Quickfix navigation
  vim.keymap.set(
    "n",
    "<M-n>",
    "<cmd>cnext<CR>",
    { desc = "Next quickfix item" }
  )
  vim.keymap.set(
    "n",
    "<M-p>",
    "<cmd>cprev<CR>",
    { desc = "Previous quickfix item" }
  )

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

  -- Buffer cycling with C-Tab
  vim.keymap.set(
    "n",
    "<C-Tab>",
    "<cmd>bnext<CR>",
    { desc = "Next buffer (cycle)" }
  )
  vim.keymap.set(
    "n",
    "<C-S-Tab>",
    "<cmd>bprevious<CR>",
    { desc = "Previous buffer (cycle)" }
  )

  -- Close buffer with leader+x
  vim.keymap.set("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close buffer" })

  -- Close all buffers except current and NvimTree with leader+X
  vim.keymap.set("n", "<leader>X", function()
    local current = vim.api.nvim_get_current_buf()
    local nvim_tree_bufs = {}

    -- Find NvimTree buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
        local ft = vim.api.nvim_buf_get_option(buf, "filetype")
        if ft == "NvimTree" then
          table.insert(nvim_tree_bufs, buf)
        end
      end
    end

    -- Close all buffers except current and NvimTree
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
        local is_nvim_tree = false
        for _, tree_buf in ipairs(nvim_tree_bufs) do
          if buf == tree_buf then
            is_nvim_tree = true
            break
          end
        end

        if buf ~= current and not is_nvim_tree then
          vim.api.nvim_buf_delete(buf, { force = false })
        end
      end
    end
  end, { desc = "Close all buffers except current and NvimTree" })

  -- Custom scroll mappings
  vim.keymap.set({ "n", "v" }, "<C-d>", function()
    local lines = math.floor(vim.api.nvim_win_get_height(0) * 0.35)
    vim.cmd("normal! " .. lines .. "jzz")
  end, { desc = "Scroll down 40%" })

  vim.keymap.set({ "n", "v" }, "<C-u>", function()
    local lines = math.floor(vim.api.nvim_win_get_height(0) * 0.35)
    vim.cmd("normal! " .. lines .. "kzz")
  end, { desc = "Scroll up 40%" })
end

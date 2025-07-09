-- https://github.com/akinsho/toggleterm.nvim
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.3
        end
      end,
      direction = "vertical",
      open_mapping = [[<C-x>]],
    })

    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set("t", "<C-h>", [[<Cmd>TmuxNavigateLeft<CR>]], opts)
      vim.keymap.set("t", "<C-j>", [[<Cmd>TmuxNavigateDown<CR>]], opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>TmuxNavigateUp<CR>]], opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>TmuxNavigateRight<CR>]], opts)
      -- vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
  end,
  enabled = false,
  -- enabled = not vim.g.vscode,
}

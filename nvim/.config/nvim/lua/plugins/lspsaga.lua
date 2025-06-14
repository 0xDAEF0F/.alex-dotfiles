-- https://github.com/nvimdev/lspsaga.nvim
-- https://nvimdev.github.io/lspsaga/
return {
  "nvimdev/lspsaga.nvim",
  config = function()
    require("lspsaga").setup({
      lightbulb = {
        virtual_text = false,
      },
      rename = {
        auto_save = true,
      },
    })
    vim.keymap.set("n", "<leader>n", "<cmd>Lspsaga hover_doc<CR>")
    vim.keymap.set("n", "<leader>e", "<cmd>Lspsaga outline<CR>")
    vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>")
    vim.keymap.set("n", "<leader>r", "<cmd>Lspsaga rename<CR>")
    vim.keymap.set("n", "(a", function()
      require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end)
    vim.keymap.set("n", ")a", function()
      require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
    end)
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "nvim-tree/nvim-web-devicons", -- optional
  },
}

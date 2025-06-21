-- https://github.com/nvim-tree/nvim-tree.lua
return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    -- disable netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- remove 's' mapping
        vim.keymap.del("n", "s", { buffer = bufnr })
      end,

      view = {
        width = 25,
      },

      actions = {
        open_file = {
          quit_on_open = false,
          window_picker = {
            enable = true,
          },
        },
      },

      -- show hidden and ignored files by default
      filters = {
        dotfiles = false,
        git_ignored = false,
      },

      tab = {
        sync = {
          open = false,
          close = false,
        },
      },
    })

    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

    vim.api.nvim_create_autocmd({ "QuitPre" }, {
      callback = function()
        vim.cmd("NvimTreeClose")
      end,
    })
  end,

  enabled = not vim.g.vscode,
}

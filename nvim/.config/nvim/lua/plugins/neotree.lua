-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    {
      "antosha417/nvim-lsp-file-operations",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-neo-tree/neo-tree.nvim",
      },
      config = function()
        require("lsp-file-operations").setup()
      end,
    },
  },

  lazy = false,

  config = function()
    vim.keymap.set(
      "n",
      "<C-e>",
      "<cmd>Neotree show toggle<CR>",
      { desc = "toggle neotree and dont lose focus" }
    )

    require("neo-tree").setup({
      close_if_last_window = true,
      use_libuv_file_watcher = true,
      enable_diagnostics = true,
      default_component_configs = {
        indent = {
          indent_size = 1,
          padding = 1,
        },
        diagnostics = {
          symbols = {
            hint = "",
            info = "",
            warn = "",
            error = "",
          },
        },
        name = {
          use_git_status_colors = false, -- disable yellow text for modified files
        },
        git_status = {
          symbols = {
            unstaged = "", -- remove unstaged icon to avoid duplication with modified
          },
        },
      },
      window = {
        width = 25,
        mappings = {
          ["s"] = function()
            require("flash").jump()
          end,
          ["<C-f>"] = function()
            require("fzf-lua-enchanted-files").files({
              actions = {
                ["ctrl-t"] = function()
                  require("fzf-lua").oldfiles({
                    query = require("fzf-lua").get_last_query(),
                  })
                end,
              },
              prompt = "Files (cwd)❯ ",
            })
          end,
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    })
  end,

  enabled = not vim.g.vscode,
}

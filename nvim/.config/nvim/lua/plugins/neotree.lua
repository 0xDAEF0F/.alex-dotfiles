-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },

  lazy = false,

  config = function()
    -- Helper function to refresh Neo-tree
    local function refresh_neo_tree()
      local ok, manager = pcall(require, "neo-tree.sources.manager")
      if ok then
        local state = manager.get_state("filesystem")
        if state then
          require("neo-tree.sources.filesystem.commands").refresh(state)
        end
      end
    end

    -- Debounced refresh to avoid excessive calls
    local refresh_timer = nil
    local function debounced_refresh(delay)
      delay = delay or 100
      if refresh_timer then
        vim.fn.timer_stop(refresh_timer)
      end
      refresh_timer = vim.fn.timer_start(delay, function()
        vim.schedule(refresh_neo_tree)
        refresh_timer = nil
      end)
    end

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
            require("fzf-lua-enchanted-files").oldfiles()
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
        -- Enable async directory scan
        async_directory_scan = "auto",
      },
      event_handlers = {},
    })

    -- Neogit events
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("NeoTreeAutoRefresh", { clear = true }),
      pattern = {
        "NeogitCommitComplete",
        "NeogitPushComplete",
        "NeogitPullComplete",
      },
      callback = function()
        debounced_refresh(300)
      end,
    })
  end,

  enabled = not vim.g.vscode,
}

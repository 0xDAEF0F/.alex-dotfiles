-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- for image rendering
  },

  lazy = false, -- neo-tree will lazily load itself

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
            error = "",
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
        -- Watch external changes
        watch = {
          enabled = true,
          debounce_delay = 50,
        },
      },
      event_handlers = {
        {
          event = "file_added",
          handler = function()
            debounced_refresh()
          end,
        },
        {
          event = "file_deleted",
          handler = function()
            debounced_refresh()
          end,
        },
        {
          event = "file_renamed",
          handler = function()
            debounced_refresh(50)
          end,
        },
      },
    })

    -- Set up autocmds
    local group = vim.api.nvim_create_augroup("NeoTreeAutoRefresh", { clear = true })

    -- Neogit events
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = {
        "NeogitStatusRefreshed",
        "NeogitCommitComplete",
        "NeogitPushComplete",
        "NeogitPullComplete",
      },
      callback = function()
        debounced_refresh(500)
      end,
    })

    -- When leaving Neogit buffers
    vim.api.nvim_create_autocmd("BufLeave", {
      group = group,
      pattern = "Neogit*",
      callback = function()
        debounced_refresh(300)
      end,
    })

    -- External file changes - when Neovim regains focus or entering buffers
    vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
      group = group,
      callback = function()
        -- Check if we're in a git repo and neo-tree is visible
        if
          vim.fn.isdirectory(".git") == 1 or vim.fn.isdirectory(vim.fn.getcwd() .. "/.git") == 1
        then
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")
            if ft == "neo-tree" then
              debounced_refresh(100)
              break
            end
          end
        end
      end,
    })

    -- After shell commands
    vim.api.nvim_create_autocmd({ "ShellCmdPost", "TermClose" }, {
      group = group,
      callback = function()
        debounced_refresh(500)
      end,
    })

    -- Git operations detection
    vim.api.nvim_create_autocmd({ "BufWritePost", "FileChangedShell", "FileChangedShellPost" }, {
      group = group,
      pattern = { "*/.git/index", "*/.git/HEAD", "*/.git/COMMIT_EDITMSG", "*" },
      callback = function(args)
        -- Special handling for git files
        if args.match:match("%.git/") then
          debounced_refresh(100)
        else
          -- For regular files, check if in git repo
          local handle = io.popen("git rev-parse --git-dir 2>/dev/null")
          if handle then
            local result = handle:read("*a")
            handle:close()
            if result and result ~= "" then
              debounced_refresh(200)
            end
          end
        end
      end,
    })

    -- Manual refresh command
    vim.api.nvim_create_user_command("NeoTreeRefresh", refresh_neo_tree, {
      desc = "Manually refresh Neo-tree",
    })
  end,

  enabled = not vim.g.vscode,
}

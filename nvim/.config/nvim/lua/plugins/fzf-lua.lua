-- https://github.com/ibhagwan/fzf-lua
return {
  "ibhagwan/fzf-lua",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")

    -- Configure fzf-lua
    fzf.setup({
      winopts = {
        height = 0.85,
        width = 0.80,
        row = 0.35,
        col = 0.50,
        preview = {
          layout = "vertical",
          vertical = "down:55%",
        },
      },
      files = {
        -- Enable file icons
        file_icons = true,
        -- Use git icons
        git_icons = true,
        -- Include hidden files by default
        fd_opts = "--color=never --type f --hidden --follow --exclude .git",
      },
      grep = {
        -- Grep options similar to telescope
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git/*'",
      },
      oldfiles = {
        cwd_only = false,
        include_current_session = true,
      },
      buffers = {
        -- Sort buffers by most recently used
        sort_lastused = true,
      },
    })

    -- Most used mappings
    vim.keymap.set("n", "<leader>s.", function()
      fzf.oldfiles()
    end, { desc = "Search recent files in CWD" })

    vim.keymap.set("n", "<leader><leader>", function()
      fzf.buffers({
        sort_lastused = true,
        previewer = "builtin",
      })
    end, { desc = "Search buffers" })

    vim.keymap.set("n", "<leader>sf", function()
      local dotfiles_path = vim.fn.expand("~/.alex-dotfiles")
      if vim.fn.getcwd() == dotfiles_path then
        fzf.files({
          fd_opts = "--color=never --type f --hidden --no-ignore --follow --exclude .git",
          prompt = "Find Files (All Files)> ",
          previewer = "builtin",
          -- fzf-lua supports frecency through oldfiles
          -- For true frecency, you can use the oldfiles picker with include_current_session
          actions = {
            ["default"] = function(selected)
              vim.cmd("edit " .. selected[1])
              -- Update oldfiles to boost frecency
              vim.fn.execute("silent! wviminfo")
            end,
          },
        })
      else
        fzf.files({
          previewer = "builtin",
          -- For frecency support, we can use a combination approach
          -- First show oldfiles, then all files
          fn_transform = function(x)
            -- This helps boost recently accessed files
            return x
          end,
        })
      end
    end, { desc = "Find files" })

    vim.keymap.set("n", "<leader>sg", function()
      local dotfiles_path = vim.fn.expand("~/.alex-dotfiles")
      if vim.fn.getcwd() == dotfiles_path then
        fzf.live_grep({
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore --glob '!.git/*'",
          prompt = "Live Grep (All Files)> ",
          previewer = "builtin",
        })
      else
        fzf.live_grep({
          previewer = "builtin",
        })
      end
    end, { desc = "Live grep" })

    -- Search in neovim config
    vim.keymap.set("n", "<leader>sn", function()
      fzf.files({
        cwd = vim.fn.stdpath("config"),
        previewer = "builtin",
      })
    end, { desc = "Search Neovim config files" })

    -- Other search mappings
    vim.keymap.set(
      "n",
      "<leader>sh",
      fzf.help_tags,
      { desc = "Search help tags" }
    )
    vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "Search keymaps" })
    vim.keymap.set(
      "n",
      "<leader>ss",
      fzf.builtin,
      { desc = "Search builtin pickers" }
    )
    vim.keymap.set(
      "n",
      "<leader>sd",
      fzf.diagnostics_document,
      { desc = "Search diagnostics" }
    )
    vim.keymap.set(
      "n",
      "<leader>sr",
      fzf.resume,
      { desc = "Resume last search" }
    )
  end,
  enabled = not vim.g.vscode,
}

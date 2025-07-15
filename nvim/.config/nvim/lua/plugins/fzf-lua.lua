-- https://github.com/ibhagwan/fzf-lua
-- https://github.com/otavioschwanck/fzf-lua-enchanted-files
return {
  {
    "otavioschwanck/fzf-lua-enchanted-files",
    dependencies = { "ibhagwan/fzf-lua" },
    event = "VimEnter",
    config = function()
      -- Modern configuration using vim.g
      vim.g.fzf_lua_enchanted_files = {
        max_history_per_cwd = 50,
      }

      local fzf = require("fzf-lua")

      fzf.setup({
        winopts = {
          height = 0.85,
          width = 0.80,
          row = 0.35,
          col = 0.50,
          preview = {
            layout = "vertical",
            vertical = "down:75%",
            scrollbar = "float",
          },
        },
        keymap = {
          builtin = {
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
          },
        },
        files = {
          fd_opts = "--color never --type f --type l --hidden --exclude .git",
        },
        grep = {
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore --glob '!.git/*' --glob '!**/target/*' --glob '!bin/*' --glob '!dist/*' --glob '!*lock*' --glob '!package-lock.json' --glob '!**/node_modules/*'",
        },
        oldfiles = {
          prompt = "History❯ ",
          cwd_only = false,
          include_current_session = true,
          actions = {
            ["ctrl-t"] = function()
              -- Toggle back to enchanted-files with the toggle action
              require("fzf-lua-enchanted-files").files({
                query = require("fzf-lua").get_last_query(),
                actions = {
                  ["ctrl-t"] = function()
                    -- Toggle back to oldfiles
                    require("fzf-lua").oldfiles({
                      query = require("fzf-lua").get_last_query(),
                    })
                  end,
                },
              })
            end,
          },
        },
        buffers = {
          sort_lastused = true,
        },
      })

      vim.keymap.set("n", "<C-g>", fzf.live_grep)
      vim.keymap.set("n", "<leader>g", fzf.grep_cword)

      vim.keymap.set("n", "<leader>ss", fzf.builtin)

      vim.keymap.set("n", "<leader>sr", fzf.resume)

      vim.keymap.set("n", "<C-b>", fzf.buffers)

      -- Enhanced files with toggle capability
      vim.keymap.set("n", "<C-f>", function()
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
      end, { desc = "Search files (ctrl-t to toggle to oldfiles)" })

      -- Search in neovim config
      vim.keymap.set("n", "<leader>sn", function()
        fzf.files({
          cwd = vim.fn.stdpath("config"),
        })
      end, { desc = "Search Neovim config files" })

      -- Other search mappings
      vim.keymap.set("n", "<leader>sh", fzf.help_tags, { desc = "Search help tags" })

      vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Search diagnostics" })
    end,
  },
}

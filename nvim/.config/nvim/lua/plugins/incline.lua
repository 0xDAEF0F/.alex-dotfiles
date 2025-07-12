-- https://github.com/b0o/incline.nvim
return {
  "b0o/incline.nvim",
  config = function()
    local devicons = require("nvim-web-devicons")

    -- Color scheme constants
    local colors = {
      bg = {
        main = "#1F1F28",
        active_buffer = "#8EA4A2",
      },
      fg = {
        active = "#16161D",
        inactive = "#9CA0B0",
        separator = "#565656",
        modified = "#111111",
      },
    }

    -- Helper functions
    local function get_listed_buffers()
      local buffers = {}
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
          table.insert(buffers, buf)
        end
      end
      return buffers
    end

    local function get_buffer_name(buf)
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
      return filename ~= "" and filename or "[No Name]"
    end

    -- Setup incline for top bar (buffers display)
    require("incline").setup({
      debounce_threshold = 30,
      window = {
        placement = {
          horizontal = "right",
          vertical = "top",
        },
        padding = 0,
        margin = { horizontal = 0, vertical = 0 },
        zindex = 50,
        winhighlight = {
          active = {
            Normal = "Normal",
          },
          inactive = {
            Normal = "Normal",
          },
        },
      },
      hide = {
        cursorline = false,
        focused_win = false,
        only_win = false,
      },
      render = function(props)
        -- Only render on window 1000 (first window)
        if props.win ~= 1000 then
          -- Check if we're the lowest window ID in the current tab
          local wins = vim.api.nvim_tabpage_list_wins(0)
          table.sort(wins)
          local first_normal_win = nil
          for _, win in ipairs(wins) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative == "" then
              first_normal_win = win
              break
            end
          end

          if props.win ~= first_normal_win then
            return {}
          end
        end

        local buffers = get_listed_buffers()
        local current_buf = vim.api.nvim_get_current_buf()
        local elements = {}

        -- Add each buffer to the display
        for i, buf in ipairs(buffers) do
          local filename = get_buffer_name(buf)
          local modified = vim.bo[buf].modified
          local is_current = buf == current_buf

          -- Get file icon
          local icon, icon_color =
            devicons.get_icon_color(filename, vim.fn.fnamemodify(filename, ":e"), { default = true })

          -- Buffer separator
          if i > 1 then
            table.insert(elements, { " │ ", guifg = colors.fg.separator })
          end

          -- Buffer content
          if is_current then
            -- For active buffer, apply blue background to icon and filename
            table.insert(elements, {
              " " .. icon .. " " .. filename .. " ",
              guibg = colors.bg.active_buffer,
              guifg = colors.fg.active,
              gui = "bold",
            })
            -- Modified indicator with different color
            if modified then
              table.insert(elements, {
                "[+]",
                guifg = colors.fg.modified,
                guibg = colors.bg.active_buffer,
                gui = "bold",
              })
            end
          else
            -- For inactive buffers
            table.insert(elements, {
              " " .. icon .. " ",
              guifg = icon_color or colors.fg.inactive,
            })
            table.insert(elements, {
              filename .. " ",
              guifg = colors.fg.inactive,
            })
            if modified then
              table.insert(elements, {
                "[+]",
                guifg = colors.fg.modified,
              })
            end
          end
        end

        return {
          elements,
          guibg = colors.bg.main,
        }
      end,
    })

    -- Load bottom bar
    require("config.bottom-bar")

    -- Refresh incline when persistence loads a session
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceLoadPost",
      callback = function()
        -- Multiple refreshes to ensure we catch all buffers
        local refresh_count = 0
        local function delayed_refresh()
          require("incline").refresh()
          refresh_count = refresh_count + 1
          if refresh_count < 3 then
            vim.defer_fn(delayed_refresh, 200)
          end
        end

        vim.defer_fn(delayed_refresh, 100)
      end,
    })

    -- Also refresh on buffer and window changes
    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufEnter", "BufWinEnter", "WinEnter" }, {
      callback = function()
        -- Use vim.schedule to avoid timing issues
        vim.schedule(function()
          require("incline").refresh()
        end)
      end,
    })
  end,
  event = "VeryLazy",
  enabled = not vim.g.vscode,
}

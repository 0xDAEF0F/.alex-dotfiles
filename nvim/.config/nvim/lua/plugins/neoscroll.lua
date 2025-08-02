return {
  "karb94/neoscroll.nvim",
  config = function()
    local neoscroll = require("neoscroll")
    neoscroll.setup({
      mappings = {},
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
      easing_function = "quadratic",
      pre_hook = nil,
      post_hook = nil,
      performance_mode = false,
    })

    local keymap = {
      ["<C-u>"] = function()
        neoscroll.ctrl_u({ duration = 100 })
      end,
      ["<C-d>"] = function()
        neoscroll.ctrl_d({ duration = 100 })
      end,
      ["zt"] = function()
        neoscroll.zt({ half_win_duration = 100 })
      end,
      ["zz"] = function()
        neoscroll.zz({ half_win_duration = 100 })
      end,
      ["zb"] = function()
        neoscroll.zb({ half_win_duration = 100 })
      end,
    }
    local modes = { "n", "v", "x" }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end,
  enabled = true,
}

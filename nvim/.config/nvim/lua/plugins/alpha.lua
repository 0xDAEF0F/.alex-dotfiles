-- https://github.com/goolord/alpha-nvim
-- https://github.com/goolord/alpha-nvim/blob/main/README.md

return {
  "goolord/alpha-nvim",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      "                                   ",
      "            ⢀⣤⣶⣿⣿⣶⣤⡀          ",
      "          ⢀⣾⣿⣿⣿⣿⣿⣿⣿⣷⡀        ",
      "         ⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆       ",
      "         ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿       ",
      "         ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿       ",
      "         ⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏       ",
      "       ⢀⣀⣀⣈⣿⣿⣿⣿⣿⣿⣿⣁⣀⣀⡀     ",
      "     ⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄   ",
      "     ⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷   ",
      "     ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿   ",
      "     ⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟   ",
      "      ⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋    ",
      "         ⠉⠛⠿⢿⣿⣿⣿⡿⠿⠛⠉       ",
      "                                   ",
    }

    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find file", ":lua require('fzf-lua-enchanted-files').files()<CR>"),
      dashboard.button("r", "󰦛  Restore session", ":lua require('persistence').load()<CR>"),
      dashboard.button("C-s", "󰊢  Open Neogit", ":lua require('neogit').open()<CR>"),
    }

    -- Custom layout
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
      dashboard.section.footer,
    }

    alpha.setup(dashboard.config)
  end,
}

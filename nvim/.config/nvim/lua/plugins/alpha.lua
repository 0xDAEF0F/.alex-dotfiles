-- https://github.com/goolord/alpha-nvim
-- https://github.com/goolord/alpha-nvim/blob/main/README.md
return {
  "goolord/alpha-nvim",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Function to get top 3 directories from zoxide
    local function get_zoxide_dirs()
      local handle = io.popen("zoxide query -l | head -5")
      if not handle then
        return {}
      end
      local result = handle:read("*a")
      handle:close()

      local dirs = {}
      for line in result:gmatch("[^\r\n]+") do
        -- Extract just the directory path (zoxide query -l shows score and path)
        local dir = line:match("^%s*%d+%.?%d*%s+(.+)$") or line
        table.insert(dirs, dir)
      end
      return dirs
    end

    -- Function to create zoxide buttons
    local function create_zoxide_buttons()
      local dirs = get_zoxide_dirs()
      local buttons = {}

      for i, dir in ipairs(dirs) do
        -- Shorten path for display
        local display_path = dir:gsub(os.getenv("HOME"), "~")
        if #display_path > 30 then
          display_path = "..." .. display_path:sub(-27)
        end

        -- Create button that uses zoxide.vim to change directory
        local button = dashboard.button(
          tostring(i),
          string.format("󰉋  %s", display_path),
          string.format(":Z %s<CR>", dir)
        )
        table.insert(buttons, button)
      end

      return buttons
    end

    -- Custom buttons with icons
    dashboard.section.buttons.val = {
      dashboard.button(
        "f",
        "󰈞  Find file",
        ":lua require('fzf-lua-enchanted-files').files()<CR>"
      ),
      dashboard.button("r", "󰦛  Restore session", ":lua require('persistence').load()<CR>"),
      dashboard.button(
        "C-s",
        "󰊢  Open Neogit",
        ":lua require('neogit').open({ kind = 'floating' })<CR>"
      ),
    }

    -- Add zoxide section
    local zoxide_section = {
      type = "group",
      val = create_zoxide_buttons(),
      opts = {
        spacing = 0,
      },
    }

    -- Zoxide header
    local zoxide_header = {
      type = "text",
      val = "Recent Directories (zoxide)",
      opts = {
        hl = "Type",
        position = "center",
      },
    }

    -- Quit button
    local quit_button = dashboard.button("q", "󰅚  Quit", ":qa<CR>")

    -- Minimal header art
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
    dashboard.section.footer.val = {}

    -- Custom layout
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      { type = "padding", val = 1 },
      zoxide_header,
      { type = "padding", val = 1 },
      zoxide_section,
      { type = "padding", val = 2 },
      quit_button,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    alpha.setup(dashboard.config)
  end,
}

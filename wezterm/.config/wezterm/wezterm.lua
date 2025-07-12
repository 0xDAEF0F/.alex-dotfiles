local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- ====================
-- Helper Functions
-- ====================

local function is_vim_process(pane)
  -- get_foreground_process_name On Linux, macOS and Windows,
  -- the process can be queried to determine this path. Other operating systems
  -- (notably, FreeBSD and other unix systems) are not currently supported
  local process_name = pane:get_foreground_process_name()
  -- Only check the actual process name, not the full path
  local base_name = process_name:match("([^/\\]+)$") or process_name
  return base_name:find("^n?vim") ~= nil
end

local function conditional_activate_pane(window, pane, pane_direction, vim_direction)
  if is_vim_process(pane) then
    window:perform_action(
      -- This should match the keybinds you set in Neovim.
      act.SendKey({ key = vim_direction, mods = "ALT" }),
      pane
    )
  else
    window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
  end
end

-- ====================
-- Event Handlers
-- ====================

-- Visual indicator for copy/search modes and zoomed panes
wezterm.on("update-right-status", function(window)
  local name = window:active_key_table()
  local overrides = window:get_config_overrides() or {}

  -- Get zoom state by checking panes_with_info
  local is_zoomed = false
  local active_tab = window:active_tab()
  if active_tab then
    for _, pane_info in ipairs(active_tab:panes_with_info()) do
      if pane_info.is_active and pane_info.is_zoomed then
        is_zoomed = true
        break
      end
    end
  end

  -- Build status elements
  local status_elements = {}

  -- Add zoom indicator if pane is zoomed
  if is_zoomed then
    table.insert(status_elements, { Background = { Color = "#C4746E" } })
    table.insert(status_elements, { Foreground = { Color = "#14171d" } })
    table.insert(status_elements, { Attribute = { Intensity = "Bold" } })
    table.insert(status_elements, { Text = " ZOOMED " })
  end

  -- Add mode indicator if in a special key table mode
  if name then
    -- Add separator if we already have zoom indicator
    if is_zoomed then
      table.insert(status_elements, { Background = { Color = "#14171d" } })
      table.insert(status_elements, { Text = " " })
    end

    table.insert(status_elements, { Background = { Color = "#8A9A7B" } })
    table.insert(status_elements, { Foreground = { Color = "#14171d" } })
    table.insert(status_elements, { Attribute = { Intensity = "Bold" } })
    table.insert(status_elements, { Text = " " .. string.upper(name:gsub("_", " ")) .. " " })

    -- Force tab bar to show when in copy mode or search mode
    if name == "copy_mode" or name == "search_mode" then
      overrides.enable_tab_bar = true
      overrides.hide_tab_bar_if_only_one_tab = false
    end
  elseif is_zoomed then
    -- Force tab bar to show when zoomed
    overrides.enable_tab_bar = true
    overrides.hide_tab_bar_if_only_one_tab = false
  else
    -- Restore normal settings
    overrides.enable_tab_bar = nil
    overrides.hide_tab_bar_if_only_one_tab = nil
  end

  -- Set the status
  if #status_elements > 0 then
    window:set_right_status(wezterm.format(status_elements))
  else
    window:set_right_status("")
  end

  window:set_config_overrides(overrides)
end)

-- Smart pane navigation (vim-aware)
wezterm.on("ActivatePaneDirection-right", function(window, pane)
  conditional_activate_pane(window, pane, "Right", "i")
end)

wezterm.on("ActivatePaneDirection-left", function(window, pane)
  conditional_activate_pane(window, pane, "Left", "h")
end)

wezterm.on("ActivatePaneDirection-up", function(window, pane)
  conditional_activate_pane(window, pane, "Up", "e")
end)

wezterm.on("ActivatePaneDirection-down", function(window, pane)
  conditional_activate_pane(window, pane, "Down", "n")
end)

-- ====================
-- Appearance
-- ====================

-- Color scheme
config.colors = {
  foreground = "#C5C9C7",
  background = "#14171d",

  cursor_bg = "#C5C9C7",
  cursor_fg = "#14171d",
  cursor_border = "#C5C9C7",

  selection_fg = "#C5C9C7",
  selection_bg = "#393B44",

  scrollbar_thumb = "#393B44",
  split = "#393B44",

  ansi = {
    "#14171d", -- black
    "#C4746E", -- red
    "#8A9A7B", -- green
    "#C4B28A", -- yellow
    "#8BA4B0", -- blue
    "#A292A3", -- magenta
    "#8EA4A2", -- cyan
    "#A4A7A4", -- white
  },
  brights = {
    "#A4A7A4", -- bright black
    "#E46876", -- bright red
    "#87A987", -- bright green
    "#E6C384", -- bright yellow
    "#7FB4CA", -- bright blue
    "#938AA9", -- bright magenta
    "#7AA89F", -- bright cyan
    "#C5C9C7", -- bright white
  },
}

-- Font configuration
config.font = wezterm.font("Iosevka Nerd Font Mono")
config.font_size = 19 -- font size that takes advantage of v screen

-- Cursor
config.force_reverse_video_cursor = true
config.default_cursor_style = "BlinkingBlock"

-- status (default 1s and its too much)
config.status_update_interval = 100

-- Window appearance
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_content_alignment = {
  horizontal = "Left",
  vertical = "Bottom",
}
config.initial_cols = 200
config.initial_rows = 60

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = true

-- Inactive pane dimming
config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.7,
}

-- ====================
-- Performance
-- ====================

config.front_end = "WebGpu"
config.animation_fps = 120
config.max_fps = 120
config.scrollback_lines = 1000000

-- ====================
-- Key Bindings
-- ====================

-- Leader key (like tmux prefix)
config.leader = { key = "a", mods = "CTRL" }

-- Mouse bindings
config.mouse_bindings = {
  -- Automatically enter copy mode when scrolling up
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = "NONE",
    action = act.Multiple({
      act.ActivateCopyMode,
      act.ScrollByCurrentEventWheelDelta,
    }),
  },
}

-- Key bindings
config.keys = {
  -- Pass through special keys
  { key = "s", mods = "CMD", action = act.SendString("\x1bs") },
  { key = "Backspace", mods = "CTRL", action = act.SendString("\x1b[127;5u") },
  { key = "Backspace", mods = "CTRL|SHIFT", action = act.SendString("\x1b[127;6u") },

  -- Window/Pane management
  { key = "x", mods = "CTRL", action = act.CloseCurrentPane({ confirm = false }) },
  { key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "z", mods = "CTRL", action = act.TogglePaneZoomState },

  -- Split panes
  { key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  {
    key = "V",
    mods = "LEADER",
    action = act.SplitPane({ direction = "Right", size = { Percent = 30 } }),
  },
  { key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

  -- Tab management
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
  { key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "n", mods = "LEADER", action = act.MoveTabRelative(1) },
  { key = "p", mods = "LEADER", action = act.MoveTabRelative(-1) },

  -- Custom new tab to the right of current
  {
    key = "t",
    mods = "CMD",
    action = wezterm.action_callback(function(window, pane)
      local mux_window = window:mux_window()
      local active_tab = window:active_tab()
      local active_idx = 0

      -- Find the index of the current tab
      for idx, tab in ipairs(mux_window:tabs()) do
        if tab:tab_id() == active_tab:tab_id() then
          active_idx = idx
          break
        end
      end

      -- Spawn new tab (goes to the end)
      local new_tab = mux_window:spawn_tab({})

      -- Move it to position right after current tab
      local total_tabs = #mux_window:tabs()
      if active_idx < total_tabs - 1 then
        -- Calculate how many positions to move left
        local moves_needed = total_tabs - active_idx - 1
        for _ = 1, moves_needed do
          window:perform_action(act.MoveTab(active_idx), pane)
        end
      end

      -- Activate the new tab
      new_tab:activate()
    end),
  },

  -- Rename tab
  {
    key = ",",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },

  -- Break pane into new tab
  {
    key = "!",
    mods = "LEADER",
    action = wezterm.action_callback(function(_, pane)
      local tab = pane:move_to_new_tab()
      tab:activate()
    end),
  },

  -- Swap panes (rotate clockwise)
  { key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },

  -- Copy mode
  { key = "p", mods = "CTRL|ALT", action = act.ActivateCopyMode },

  -- Search
  { key = "/", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },

  -- Pane navigation (vim-aware)
  { key = "h", mods = "ALT", action = act.EmitEvent("ActivatePaneDirection-left") },
  { key = "n", mods = "ALT", action = act.EmitEvent("ActivatePaneDirection-down") },
  { key = "e", mods = "ALT", action = act.EmitEvent("ActivatePaneDirection-up") },
  { key = "i", mods = "ALT", action = act.EmitEvent("ActivatePaneDirection-right") },

  -- Resize panes
  { key = "LeftArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 10 }) },
  { key = "RightArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 10 }) },
  { key = "UpArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 10 }) },
  { key = "DownArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 10 }) },
}

-- ====================
-- Key Tables
-- ====================

config.key_tables = {
  copy_mode = {
    -- Mode selection
    { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
    { key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },

    -- Copy and exit
    {
      key = "y",
      mods = "NONE",
      action = act.Multiple({
        { CopyTo = "ClipboardAndPrimarySelection" },
        { CopyMode = "Close" },
      }),
    },

    -- Exit copy mode
    {
      key = "Escape",
      mods = "NONE",
      action = act.Multiple({
        act.ScrollToBottom,
        { CopyMode = "Close" },
      }),
    },
    {
      key = "q",
      mods = "NONE",
      action = act.Multiple({
        act.ScrollToBottom,
        { CopyMode = "Close" },
      }),
    },

    -- Vi navigation
    { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
    { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
    { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
    { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },

    -- Arrow navigation
    { key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
    { key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
    { key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
    { key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },

    -- Word navigation
    { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
    { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
    { key = "e", action = act.CopyMode("MoveForwardWordEnd") },

    -- Line navigation
    { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
    { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },

    -- Page navigation
    { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
    { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },

    -- Document navigation
    { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
    { key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },

    -- Search
    { key = "/", mods = "NONE", action = act.Search({ CaseInSensitiveString = "" }) },
    { key = "?", mods = "NONE", action = act.Search({ CaseInSensitiveString = "" }) },
    { key = "N", mods = "NONE", action = act.CopyMode("NextMatch") },
    { key = "n", mods = "SHIFT", action = act.CopyMode("PriorMatch") },
    { key = "c", mods = "CTRL", action = act.CopyMode("ClearPattern") },
  },

  search_mode = {
    { key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
    { key = "Enter", mods = "SHIFT", action = act.CopyMode("NextMatch") },
    -- Exit search mode but stay in copy mode with the search pattern active
    {
      key = "Escape",
      mods = "NONE",
      action = act.Multiple({
        act.CopyMode("AcceptPattern"),
        act.CopyMode("ClearPattern"),
      }),
    },
  },
}

-- ====================
-- Miscellaneous
-- ====================

config.enable_csi_u_key_encoding = true
config.quit_when_all_windows_are_closed = true
config.window_close_confirmation = "NeverPrompt"

return config

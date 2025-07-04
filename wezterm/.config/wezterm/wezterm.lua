local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

local function isViProcess(pane)
	-- get_foreground_process_name On Linux, macOS and Windows,
	-- the process can be queried to determine this path. Other operating systems
	-- (notably, FreeBSD and other unix systems) are not currently supported
	return pane:get_foreground_process_name():find("n?vim") ~= nil
		or pane:get_title():find("n?vim") ~= nil
end

local function conditionalActivatePane(
	window,
	pane,
	pane_direction,
	vim_direction
)
	if isViProcess(pane) then
		window:perform_action(
			-- This should match the keybinds you set in Neovim.
			act.SendKey({ key = vim_direction, mods = "ALT" }),
			pane
		)
	else
		window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
	end
end

wezterm.on("ActivatePaneDirection-right", function(window, pane)
	conditionalActivatePane(window, pane, "Right", "i")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
	conditionalActivatePane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
	conditionalActivatePane(window, pane, "Up", "e")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
	conditionalActivatePane(window, pane, "Down", "n")
end)

config.force_reverse_video_cursor = true

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
		"#14171d",
		"#C4746E",
		"#8A9A7B",
		"#C4B28A",
		"#8BA4B0",
		"#A292A3",
		"#8EA4A2",
		"#A4A7A4",
	},
	brights = {
		"#A4A7A4",
		"#E46876",
		"#87A987",
		"#E6C384",
		"#7FB4CA",
		"#938AA9",
		"#7AA89F",
		"#C5C9C7",
	},
}

-- Window settings
config.initial_cols = 200
config.initial_rows = 60

config.window_decorations = "RESIZE"

-- Remove all padding
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

-- Font settings
config.font = wezterm.font("Iosevka Nerd Font Mono")
config.font_size = 22

-- Cursor settings
config.default_cursor_style = "BlinkingBlock"

-- Scrollback
config.scrollback_lines = 1000000

-- Tab bar - defaults
-- config.enable_tab_bar = true
-- config.tab_bar_at_bottom = false
-- config.hide_tab_bar_if_only_one_tab = true
-- config.use_fancy_tab_bar = true

-- Leader key (like tmux prefix)
config.leader = { key = "a", mods = "CTRL" }

-- Key bindings
config.keys = {
	-- Pass through cmd+s for neovim
	{ key = "s", mods = "CMD", action = act.SendString("\x1bs") },

	-- Pass ctrl+backspace through to applications
	{ key = "Backspace", mods = "CTRL", action = act.SendString("\x1b[127;5u") },

	-- Kill pane
	{
		key = "x",
		mods = "CTRL",
		action = act.CloseCurrentPane({ confirm = false }),
	},

	-- kill tab
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
	},

	-- Split panes (like tmux)
	{
		key = "v",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "V",
		mods = "LEADER",
		action = act.SplitPane({ direction = "Right", size = { Percent = 30 } }),
	},
	{
		key = "s",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },

	-- Copy mode (like tmux C-M-p)
	{ key = "p", mods = "CTRL|ALT", action = act.ActivateCopyMode },

	-- Tab navigation
	{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "Space", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = "Space", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },

	-- Zoom pane (like tmux C-z)
	{ key = "z", mods = "CTRL", action = act.TogglePaneZoomState },

	-- Resize panes (like tmux)
	{
		key = "LeftArrow",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "RightArrow",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "UpArrow",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "DownArrow",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},

	{
		key = "h",
		mods = "ALT",
		action = act.EmitEvent("ActivatePaneDirection-left"),
	},
	{
		key = "n",
		mods = "ALT",
		action = act.EmitEvent("ActivatePaneDirection-down"),
	},
	{
		key = "e",
		mods = "ALT",
		action = act.EmitEvent("ActivatePaneDirection-up"),
	},
	{
		key = "i",
		mods = "ALT",
		action = act.EmitEvent("ActivatePaneDirection-right"),
	},

	-- Search (like tmux incremental search)
	{
		key = "/",
		mods = "LEADER",
		action = act.Search("CurrentSelectionOrEmptyString"),
	},
}

-- Copy mode key table (vi-like)
config.key_tables = {
	copy_mode = {
		{
			key = "v",
			mods = "NONE",
			action = act.CopyMode({ SetSelectionMode = "Cell" }),
		},
		{
			key = "V",
			mods = "SHIFT",
			action = act.CopyMode({ SetSelectionMode = "Line" }),
		},
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({
				{ CopyTo = "ClipboardAndPrimarySelection" },
				{ CopyMode = "Close" },
			}),
		},

		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "q", mods = "NONE", action = act.CopyMode("Close") },

		-- Vi navigation
		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
		-- Arrow key navigation
		{ key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
		-- Word navigation
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		-- Page navigation
		{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
		{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
		-- Line navigation

		{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{
			key = "$",
			mods = "NONE",
			action = act.CopyMode("MoveToEndOfLineContent"),
		},
		-- Search mode
		{
			key = "/",
			mods = "NONE",
			action = act.Search("CurrentSelectionOrEmptyString"),
		},
	},

	search_mode = {
		{ key = "Enter", mods = "NONE", action = act.CopyMode("NextMatch") },
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
		{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
	},
}

-- Shell integration
config.enable_csi_u_key_encoding = true

-- Quit when last window closed
config.quit_when_all_windows_are_closed = true
config.window_close_confirmation = "NeverPrompt"

-- Use resize increments to snap to cell boundaries
config.use_resize_increments = true

return config

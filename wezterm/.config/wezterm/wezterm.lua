local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

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

-- Theme
config.color_scheme = "Kanagawa (Gogh)"

-- Cursor settings
config.default_cursor_style = "BlinkingBlock"

-- Scrollback
config.scrollback_lines = 100000

-- Tab bar - minimal at bottom, hidden with single tab
config.enable_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true

-- Leader key (like tmux prefix)
config.leader = { key = "a", mods = "CTRL" }

-- Key bindings
config.keys = {
	-- Pass through cmd+s for neovim
	{ key = "s", mods = "CMD", action = act.SendString("\x1bs") },

	-- Fix ctrl+tab for terminal applications
	{ key = "Tab", mods = "CTRL", action = act.SendString("\x1b[9;5u") },
	{ key = "Tab", mods = "CTRL|SHIFT", action = act.SendString("\x1b[1;5Z") },

	-- Pass ctrl+backspace through to applications
	{ key = "Backspace", mods = "CTRL", action = act.SendString("\x1b[127;5u") },

	-- Kill pane (like tmux C-x)
	{
		key = "x",
		mods = "CTRL",
		action = act.CloseCurrentPane({ confirm = false }),
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

	-- Reload config (like tmux r)
	{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },

	-- Tab navigation (like tmux C-Space)
	{ key = "Space", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "CTRL", action = act.ActivateTabRelative(-1) },

	-- Zoom pane (like tmux C-z)
	{ key = "z", mods = "CTRL", action = act.TogglePaneZoomState },

	-- Move tabs (like tmux n/p for swap)
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },

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

	-- Navigate panes (vim-like, similar to vim-tmux-navigator)
	{ key = "h", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CTRL", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CTRL", action = act.ActivatePaneDirection("Right") },

	-- Search (like tmux incremental search)
	{
		key = "/",
		mods = "LEADER",
		action = act.Search("CurrentSelectionOrEmptyString"),
	},

	-- Show tab navigator overlay (to see tab list when needed)
	{ key = "w", mods = "LEADER", action = act.ShowTabNavigator },

	-- Font size adjustments
	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },
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
		-- Word navigation
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		-- Page navigation
		{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
		{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
		-- Line navigation
		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
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

-- Enable multiplexer features
config.unix_domains = {
	{
		name = "unix",
	},
}

-- Use resize increments to snap to cell boundaries
config.use_resize_increments = true

return config

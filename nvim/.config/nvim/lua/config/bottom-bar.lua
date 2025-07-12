-- Color scheme constants
local colors = {
  bg = {
    main = "#1F1F28",
    active_buffer = "#7FB4CA",
  },
  fg = {
    active = "#16161D",
    inactive = "#9CA0B0",
    separator = "#565656",
    modified = "#C4746E",
  },
  modes = {
    n = { color = "#7FB4CA" },
    i = { color = "#8A9A7B" },
    v = { color = "#A292A3" },
    V = { color = "#A292A3" },
    R = { color = "#C4746E" },
    c = { color = "#C4B28A" },
    t = { color = "#8EA4A2" },
  },
}

-- Shared list of filetypes to skip
local skip_filetypes = {
  "NvimTree",
  "neo-tree",
  "nerdtree",
  "tagbar",
  "vista",
  "Outline",
  "outline",
  "aerial",
  "packer",
  "lazy",
  "mason",
  "TelescopePrompt",
  "dashboard",
  "alpha",
  "starter",
  "fugitive",
  "git",
  "gitcommit",
  "DiffviewFiles",
  "Trouble",
  "qf",
  "help",
  "man",
  "lspinfo",
  "oil",
  "minifiles",
  "neo-tree-popup",
  "noice",
  "notify",
  "sagaoutline",
  "sagafinder",
  "sagarename",
  "floaterm",
}

-- Function to check if a filetype should be skipped
local function should_skip_filetype(filetype)
  for _, ft in ipairs(skip_filetypes) do
    if
      filetype == ft
      or filetype:lower() == ft:lower()
      or filetype:match("neo%-tree")
      or filetype:match("Outline")
      or filetype:match("outline")
    then
      return true
    end
  end
  return false
end

local function get_git_branch(path)
  local handle =
    io.popen("git -C " .. vim.fn.shellescape(path) .. " branch --show-current 2>/dev/null")
  if not handle then
    return ""
  end
  local branch = handle:read("*a"):gsub("\n", "")
  handle:close()
  return branch
end

local function get_location_info()
  local cwd = vim.fn.getcwd()

  -- Check if we're in a git repo and get the root
  local handle =
    io.popen("git -C " .. vim.fn.shellescape(cwd) .. " rev-parse --show-toplevel 2>/dev/null")
  if handle then
    local git_root = handle:read("*a"):gsub("\n", "")
    handle:close()
    if git_root ~= "" then
      -- In a git repo, show the git root directory name
      local git_root_name = vim.fn.fnamemodify(git_root, ":t")
      return " 󰉋 " .. git_root_name .. " "
    end
  end

  -- Not in a git repo, show current directory name
  local dir_name = vim.fn.fnamemodify(cwd, ":t")
  return " 󰉋 " .. dir_name .. " "
end

-- Custom bottom bar implementation
local bottom_bars = {}

local function update_bottom_bar_content(win, float_win, buf)
  if not vim.api.nvim_win_is_valid(win) or not vim.api.nvim_win_is_valid(float_win) then
    return
  end

  -- Update position in case window was resized
  local current_win_width = vim.api.nvim_win_get_width(win)
  local current_win_height = vim.api.nvim_win_get_height(win)
  local current_win_pos = vim.api.nvim_win_get_position(win)

  -- Get current mode
  local mode = vim.fn.mode()
  local mode_info = colors.modes[mode]
  local mode_color = mode_info and mode_info.color or "#393B44"

  -- Get location info (git commit or cwd)
  local location_info = get_location_info()

  -- Get git branch
  local git_branch = get_git_branch(vim.fn.expand("%:p:h"))

  -- Format content with mode highlighting
  local ns_id = vim.api.nvim_create_namespace("bottom_bar_" .. win)
  vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)

  -- Build content
  local location_section = location_info
  local separator = " │ "
  local git_section = git_branch ~= "" and "󰊢 " .. git_branch or "No Git"
  local content = location_section .. separator .. " " .. git_section .. " "

  -- Update bar width based on content length
  local bar_width = vim.fn.strwidth(content) + 2

  -- Update window position and size
  vim.api.nvim_win_set_config(float_win, {
    relative = "editor",
    width = bar_width,
    height = 1,
    row = current_win_pos[1] + current_win_height - 1,
    col = current_win_pos[2] + current_win_width - bar_width,
  })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { content })

  -- Apply normal highlight to location section
  vim.api.nvim_buf_add_highlight(buf, ns_id, "StatusLine", 0, 0, #location_section)

  -- Skip separator
  local separator_start = #location_section
  local separator_end = separator_start + #separator

  -- Apply mode color highlight to git branch section
  local hl_group = "BottomBarMode" .. win
  vim.api.nvim_set_hl(0, hl_group, { fg = mode_color, bold = true })
  vim.api.nvim_buf_add_highlight(buf, ns_id, hl_group, 0, separator_end, -1)
  vim.api.nvim_win_set_option(float_win, "winhl", "Normal:StatusLine")
end

local function create_bottom_bar(win)
  if bottom_bars[win] and vim.api.nvim_win_is_valid(bottom_bars[win]) then
    return
  end

  -- Check if this is a regular buffer window
  local win_buf = vim.api.nvim_win_get_buf(win)
  local buftype = vim.bo[win_buf].buftype
  local filetype = vim.bo[win_buf].filetype

  -- Skip special buffer types and common plugin filetypes
  if buftype ~= "" then
    return -- Skip if buftype is set (terminal, quickfix, help, etc.)
  end

  -- Skip common plugin windows
  if should_skip_filetype(filetype) then
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"

  local win_width = vim.api.nvim_win_get_width(win)
  local win_height = vim.api.nvim_win_get_height(win)
  local win_pos = vim.api.nvim_win_get_position(win)

  -- Calculate width based on content (approximate)
  local bar_width = 35

  local float_win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = bar_width,
    height = 1,
    row = win_pos[1] + win_height - 1,
    col = win_pos[2] + win_width - 1, -- Position at right edge
    focusable = false,
    style = "minimal",
    border = "none",
    noautocmd = true,
  })

  bottom_bars[win] = float_win

  -- Initial content update
  update_bottom_bar_content(win, float_win, buf)

  -- Set up autocmds for this window
  local group = vim.api.nvim_create_augroup("BottomBar_" .. win, { clear = true })
  vim.api.nvim_create_autocmd({
    "CursorMoved",
    "CursorMovedI",
    "BufEnter",
    "ModeChanged",
    "WinResized",
  }, {
    group = group,
    pattern = "*",
    callback = function()
      update_bottom_bar_content(win, float_win, buf)
    end,
  })

  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    pattern = tostring(win),
    callback = function()
      if bottom_bars[win] and vim.api.nvim_win_is_valid(bottom_bars[win]) then
        vim.api.nvim_win_close(bottom_bars[win], true)
      end
      bottom_bars[win] = nil
      vim.api.nvim_del_augroup_by_id(group)
    end,
  })
end

-- Function to check if a window should have a bottom bar
local function should_have_bottom_bar(win)
  if not vim.api.nvim_win_is_valid(win) then
    return false
  end

  -- Check if it's a floating window
  if vim.api.nvim_win_get_config(win).relative ~= "" then
    return false
  end

  local win_buf = vim.api.nvim_win_get_buf(win)
  local buftype = vim.bo[win_buf].buftype
  local filetype = vim.bo[win_buf].filetype

  -- Skip special buffer types
  if buftype ~= "" then
    return false
  end

  return not should_skip_filetype(filetype)
end

-- Function to remove bottom bar if it shouldn't exist
local function cleanup_bottom_bar(win)
  if bottom_bars[win] and not should_have_bottom_bar(win) then
    if vim.api.nvim_win_is_valid(bottom_bars[win]) then
      vim.api.nvim_win_close(bottom_bars[win], true)
    end
    bottom_bars[win] = nil
  end
end

-- Create bottom bars for existing windows and new ones
vim.api.nvim_create_autocmd({ "WinNew", "WinEnter", "VimEnter", "FileType", "BufWinEnter" }, {
  callback = function()
    -- Check all windows
    for win, _ in pairs(bottom_bars) do
      cleanup_bottom_bar(win)
    end

    -- Create for current window if needed
    local win = vim.api.nvim_get_current_win()
    if should_have_bottom_bar(win) then
      create_bottom_bar(win)
    end
  end,
})

-- Initial creation for all windows
for _, win in ipairs(vim.api.nvim_list_wins()) do
  if should_have_bottom_bar(win) then
    create_bottom_bar(win)
  end
end

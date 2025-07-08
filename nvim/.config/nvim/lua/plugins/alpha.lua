-- https://github.com/goolord/alpha-nvim
-- https://github.com/goolord/alpha-nvim/blob/main/README.md
return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local theta = require("alpha.themes.theta")

		-- Custom buttons with icons
		dashboard.section.buttons.val = {
			dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button(
				"C-f",
				"󰈞  Find file",
				":lua require('fzf-lua-enchanted-files').files()<CR>"
			),
		}

		-- Create recent files section
		local recent_files_header = {
			type = "text",
			val = "  Recent Files",
			opts = {
				hl = "SpecialComment",
				shrink_margin = false,
				position = "center",
			},
		}

		-- Get recent files
		local function get_recent_files()
			local mru_files = {}
			local oldfiles = vim.v.oldfiles
			local cwd = vim.fn.getcwd()

			for _, file in ipairs(oldfiles) do
				if vim.fn.filereadable(file) == 1 then
					table.insert(mru_files, file)
					if #mru_files >= 5 then
						break
					end
				end
			end

			return mru_files
		end

		-- Create recent files buttons
		local function recent_files_buttons()
			local buttons = {}
			local files = get_recent_files()

			for i, file in ipairs(files) do
				local filename = vim.fn.fnamemodify(file, ":t")
				local path = vim.fn.fnamemodify(file, ":~:.")
				local button_text = string.format("  %s", path)

				table.insert(
					buttons,
					dashboard.button(tostring(i), button_text, ":e " .. file .. "<CR>")
				)
			end

			return buttons
		end

		-- Create recent files group
		local recent_files_section = {
			type = "group",
			val = function()
				local elements = { recent_files_header }
				local buttons = recent_files_buttons()
				for _, button in ipairs(buttons) do
					table.insert(elements, button)
				end
				return elements
			end,
			opts = {
				spacing = 0,
			},
		}

		-- Quit button
		local quit_button = dashboard.button("q", "󰅚  Quit", ":qa<CR>")

		-- Minimal header art
		dashboard.section.header.val = {
			"                                                     ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
			"                                                     ",
		}
		dashboard.section.footer.val = {}

		-- Custom layout with recent files section
		dashboard.config.layout = {
			{ type = "padding", val = 2 },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			{ type = "padding", val = 1 },
			recent_files_section,
			{ type = "padding", val = 1 },
			quit_button,
			{ type = "padding", val = 1 },
			dashboard.section.footer,
		}

		alpha.setup(dashboard.config)
	end,
}

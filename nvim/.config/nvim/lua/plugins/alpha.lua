-- https://github.com/goolord/alpha-nvim
-- https://github.com/goolord/alpha-nvim/blob/main/README.md
return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Custom buttons with icons
		dashboard.section.buttons.val = {
			dashboard.button(
				"f",
				"󰈞  Find file",
				":lua require('fzf-lua-enchanted-files').files()<CR>"
			),
			dashboard.button(
				"s",
				"󰊢  Open Neogit",
				":lua require('neogit').open({ kind = 'floating' })<CR>"
			),
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
			quit_button,
			{ type = "padding", val = 1 },
			dashboard.section.footer,
		}

		alpha.setup(dashboard.config)
	end,
}

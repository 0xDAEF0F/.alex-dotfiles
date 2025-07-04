-- https://github.com/ibhagwan/fzf-lua
return {
	"ibhagwan/fzf-lua",
	-- dir = "/Users/ale/mimi/erepos/fzf-lua",
	name = "fzf-lua",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzf = require("fzf-lua")

		-- Custom hybrid provider with markers
		local function custom_hybrid(opts)
			local core = require("fzf-lua.core")
			local config = require("fzf-lua.config")
			local make_entry = require("fzf-lua.make_entry")
			local path = require("fzf-lua.path")
			local utils = require("fzf-lua.utils")

			opts = opts or {}
			opts = config.normalize_opts(opts, "files")
			if not opts then
				return
			end

			-- Set defaults
			opts.show_buffers = opts.show_buffers ~= false
			opts.show_oldfiles = opts.show_oldfiles ~= false
			opts.show_files = opts.show_files ~= false
			opts.include_current_session = opts.include_current_session ~= false
			opts.cwd_only = opts.cwd_only ~= false
			opts.cwd = opts.cwd or vim.loop.cwd()

			-- Force multiprocess to false for hybrid approach
			opts.multiprocess = false

			local contents = function(fzf_cb)
				coroutine.wrap(function()
					local seen = {}
					local displayed = {} -- Track files currently displayed in windows
					local counts = { buffers = 0, oldfiles = 0, files = 0 }

					-- Get fresh buffer list
					core.CTX({ includeBuflist = true })

					-- First, collect all files currently displayed in windows
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local bufnr = vim.api.nvim_win_get_buf(win)
						local bufinfo = utils.getbufinfo(bufnr)
						if bufinfo and bufinfo.name and bufinfo.name ~= "" then
							local fullpath = vim.fn.fnamemodify(bufinfo.name, ":p")
							displayed[fullpath] = true
						end
					end

					-- Phase 1: Get current buffers (highest priority)
					if opts.show_buffers then
						local buflist = vim.api.nvim_list_bufs()
						for _, bufnr in ipairs(buflist) do
							local bufinfo = utils.getbufinfo(bufnr)
							if
								bufinfo
								and bufinfo.loaded == 1
								and bufinfo.name
								and bufinfo.name ~= ""
							then
								-- Skip special buffers
								local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
								local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

								-- Skip non-normal buftypes (terminal, quickfix, help, etc)
								if buftype ~= "" and buftype ~= "acwrite" then
									goto continue
								end

								-- Skip neo-tree buffers
								if
									filetype == "neo-tree" or bufinfo.name:match("neo%-tree")
								then
									goto continue
								end

								-- Skip OUTLINE buffers
								if bufinfo.name:match("OUTLINE") then
									goto continue
								end

								local fullpath = vim.fn.fnamemodify(bufinfo.name, ":p")

								-- Skip buffers that are currently displayed in a window
								if displayed[fullpath] then
									goto continue
								end

								if not seen[fullpath] then
									seen[fullpath] = true
									counts.buffers = counts.buffers + 1
									local entry = make_entry.file(fullpath, opts)

									-- Add source marker and buffer indicators
									entry = "[B] " .. entry
									if bufnr == vim.fn.bufnr("%") then
										entry = entry .. " %"
									elseif bufnr == vim.fn.bufnr("#") then
										entry = entry .. " #"
									end

									fzf_cb(entry)
								end
							end
							::continue::
						end
					end

					-- Phase 2: Get oldfiles (medium priority)
					if opts.show_oldfiles then
						-- Get vim's oldfiles
						for _, file in ipairs(vim.v.oldfiles or {}) do
							local fullpath = vim.fn.fnamemodify(file, ":p")
							if
								not seen[fullpath]
								and not displayed[fullpath]
								and utils.file_is_readable(fullpath)
							then
								-- Check cwd_only
								if
									not opts.cwd_only or path.is_relative_to(fullpath, opts.cwd)
								then
									seen[fullpath] = true
									counts.oldfiles = counts.oldfiles + 1
									local entry = make_entry.file(fullpath, opts)
									entry = "[O] " .. entry
									fzf_cb(entry)
								end
							end
						end

						-- Include current session files if requested
						if opts.include_current_session then
							local ok, buffers_output = pcall(vim.fn.execute, ":buffers! t")
							if ok then
								for _, buffer in ipairs(vim.split(buffers_output, "\n")) do
									local bufnr = tonumber(buffer:match("%s*(%d+)"))
									if bufnr then
										local bufinfo = utils.getbufinfo(bufnr)
										if bufinfo and bufinfo.name and bufinfo.name ~= "" then
											local fullpath = vim.fn.fnamemodify(bufinfo.name, ":p")
											if
												not seen[fullpath]
												and not displayed[fullpath]
												and utils.file_is_readable(fullpath)
											then
												if
													not opts.cwd_only
													or path.is_relative_to(fullpath, opts.cwd)
												then
													seen[fullpath] = true
													counts.oldfiles = counts.oldfiles + 1
													local entry = make_entry.file(fullpath, opts)
													entry = "[O] " .. entry
													fzf_cb(entry)
												end
											end
										end
									end
								end
							end
						end
					end

					-- Phase 3: Get all files (lowest priority)
					if opts.show_files then
						local cmd = nil
						if opts.cmd and #opts.cmd > 0 then
							cmd = opts.cmd
						elseif vim.fn.executable("fd") == 1 then
							cmd = "fd --color=never --type f --hidden --follow --exclude .git"
						elseif vim.fn.executable("rg") == 1 then
							cmd = "rg --color=never --files --hidden --follow -g '!.git'"
						else
							cmd = "find . -type f -not -path '*/\\.git/*' 2>/dev/null"
						end

						-- Run the command and process output
						local stdout = vim.loop.new_pipe(false)
						local stderr = vim.loop.new_pipe(false)

						local handle = vim.loop.spawn("sh", {
							args = { "-c", cmd },
							cwd = opts.cwd,
							stdio = { nil, stdout, stderr },
						}, function(code)
							-- Command finished
							stdout:close()
							stderr:close()
							if code ~= 0 and code ~= 130 and code ~= 129 then
								utils.err(string.format("'%s' exited with code %d", cmd, code))
							end
							vim.schedule(function()
								fzf_cb(nil)
							end)
						end)

						if handle then
							stdout:read_start(function(err, data)
								if data then
									-- Process each line
									for line in data:gmatch("[^\r\n]+") do
										if line ~= "" then
											local fullpath =
												vim.fn.fnamemodify(path.join({ opts.cwd, line }), ":p")
											if not seen[fullpath] and not displayed[fullpath] then
												seen[fullpath] = true
												counts.files = counts.files + 1
												local entry = make_entry.file(line, opts)
												entry = "[F] " .. entry
												vim.schedule(function()
													fzf_cb(entry)
												end)
											end
										end
									end
								end
							end)
						else
							-- If no files command, just signal completion
							fzf_cb(nil)
						end
					else
						-- Signal completion if not showing files
						fzf_cb(nil)
					end
				end)()
			end

			opts = core.set_header(opts, opts.headers or { "cwd" })
			return core.fzf_exec(contents, opts)
		end

		fzf.setup({
			winopts = {
				height = 0.85,
				width = 0.80,
				row = 0.35,
				col = 0.50,
				preview = {
					layout = "vertical",
					vertical = "down:55%",
					scrollbar = "float",
				},
			},
			keymap = {
				builtin = {
					["<C-d>"] = "preview-page-down",
					["<C-u>"] = "preview-page-up",
				},
			},
			files = {
				fd_opts = "--color never --type f --type l --hidden --exclude .git",
			},
			grep = {
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore --glob '!.git/*' --glob '!**/target/*' --glob '!bin/*' --glob '!dist/*' --glob '!*lock*' --glob '!package-lock.json' --glob '!**/node_modules/*'",
			},
			oldfiles = {
				prompt = "History❯ ",
				cwd_only = true,
				include_current_session = true,
			},
			buffers = {
				sort_lastused = true,
			},
		})

		-- Most used mappings
		-- vim.keymap.set("n", "<leader><leader>", fzf.buffers)
		-- vim.keymap.set("n", "<C-f>", fzf.oldfiles)
		-- vim.keymap.set("n", "<C-.>", fzf.files)

		vim.keymap.set("n", "<C-g>", fzf.live_grep)

		vim.keymap.set("n", "<leader>ss", fzf.builtin)

		vim.keymap.set("n", "<leader>sr", fzf.resume)

		-- Hybrid picker with markers
		vim.keymap.set(
			"n",
			"<C-f>",
			custom_hybrid,
			{ desc = "Search files (hybrid)" }
		)

		-- Search in neovim config
		vim.keymap.set("n", "<leader>sn", function()
			fzf.files({
				cwd = vim.fn.stdpath("config"),
				previewer = "builtin",
			})
		end, { desc = "Search Neovim config files" })

		-- Other search mappings
		vim.keymap.set(
			"n",
			"<leader>sh",
			fzf.help_tags,
			{ desc = "Search help tags" }
		)

		vim.keymap.set(
			"n",
			"<leader>sd",
			fzf.diagnostics_document,
			{ desc = "Search diagnostics" }
		)

		-- Open custom_hybrid on VimEnter when no arguments
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				-- Check if no arguments and buffer is empty
				if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
					-- Defer execution to ensure everything is loaded
					vim.defer_fn(function()
						custom_hybrid()
					end, 0)
				end
			end,
		})
	end,

	enabled = not vim.g.vscode,
}

return {
  "echasnovski/mini.nvim",
  config = function()
    local statusline = require("mini.statusline")

    -- custom active content function
    local active = function()
      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local git = statusline.section_git({ trunc_width = 75 })
      local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })

      -- custom filename section
      local filename = vim.fn.expand("%:p")
      if filename == "" then
        filename = "[No Name]"
      else
        -- get git root
        local git_root = vim.fn
          .system(
            "git -C "
              .. vim.fn.shellescape(vim.fn.expand("%:p:h"))
              .. " rev-parse --show-toplevel 2>/dev/null"
          )
          :gsub("\n", "")

        if vim.v.shell_error == 0 and git_root ~= "" then
          -- make path relative to git root but include repo name
          local repo_name = vim.fn.fnamemodify(git_root, ":t")
          local relative_path = filename:sub(#git_root + 2)
          if filename:sub(1, #git_root) == git_root then
            filename = repo_name .. "/" .. relative_path
          end
        else
          -- not in git repo, show relative to current directory
          filename = vim.fn.fnamemodify(filename, ":~:.")
        end
      end

      -- add modified flag
      if vim.bo.modified then
        filename = filename .. " +"
      end

      -- truncate if needed
      local args = { trunc_width = 140 }
      if #filename > 40 and not MiniStatusline.is_truncated(args.trunc_width) then
        filename = vim.fn.pathshorten(filename)
      end

      local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
      local location = "%2l:%-2v"
      local search = statusline.section_searchcount({ trunc_width = 75 })

      return statusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl, strings = { search, location } },
      })
    end

    statusline.setup({
      use_icons = true,
      content = {
        active = active,
        inactive = nil,
      },
    })
    require("mini.pairs").setup()
    require("mini.icons").setup()
    MiniIcons.tweak_lsp_kind()
    require("mini.comment").setup({})
  end,
  enabled = not vim.g.vscode,
}

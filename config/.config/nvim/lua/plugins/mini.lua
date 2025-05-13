return {
  "echasnovski/mini.nvim",
  config = function()
    local statusline = require("mini.statusline")
    statusline.setup({ use_icons = true })
    statusline.section_location = function()
      return "%2l:%-2v"
    end
    require("mini.pairs").setup()
    require("mini.icons").setup()
    MiniIcons.tweak_lsp_kind()
    require("mini.comment").setup()
  end,
  enabled = not vim.g.vscode,
}

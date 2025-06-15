return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    sections = {
      lualine_c = {
        { "filename", path = 1 },
      },
      lualine_x = {
        {
          "lsp_status",
          icon = "", -- f013
          symbols = {
            -- Standard unicode symbols to cycle through for LSP progress:
            spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
            -- Standard unicode symbol for when LSP is done:
            done = "✓",
            -- Delimiter inserted between LSP names:
            separator = " ",
          },
        },
        "filetype",
      },
    },
  },
  enabled = not vim.g.vscode,
}

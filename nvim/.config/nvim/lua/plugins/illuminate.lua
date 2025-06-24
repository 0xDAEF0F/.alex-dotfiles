-- https://github.com/RRethy/vim-illuminate
return {
  -- Highlight other instances of the word under the cursor
  "RRethy/vim-illuminate",
  event = "VeryLazy",
  config = function()
    require("illuminate").configure({
      min_count_to_highlight = 2,
      delay = 200,
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      under_cursor = true,
      providers_regex_syntax_denylist = {
        "String",
        "Character",
        "Constant",
        "SpecialChar",
      },
    })
    -- this shouldnt be necessary (but it is)
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { underline = true })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { underline = true })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { underline = true })
  end,
}

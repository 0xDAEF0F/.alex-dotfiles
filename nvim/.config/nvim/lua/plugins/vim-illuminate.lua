return {
  -- Highlight other instances of the word under the cursor
  "RRethy/vim-illuminate",
  event = "VeryLazy",
  config = function()
    require("illuminate").configure({
      min_count_to_highlight = 2,
    })
  end,
}

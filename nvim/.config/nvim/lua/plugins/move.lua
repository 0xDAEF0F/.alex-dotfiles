return {
  "fedepujol/move.nvim",
  keys = {
    -- Normal Mode
    { "<A-j>", "<cmd>MoveLine(1)<CR>", desc = "Move Line Up" },
    { "<A-k>", "<cmd>MoveLine(-1)<CR>", desc = "Move Line Down" },
    -- Visual Mode
    { "<A-j>", "<cmd>MoveBlock(1)<CR>", mode = { "v" }, desc = "Move Block Up" },
    { "<A-k>", "<cmd>MoveBlock(-1)<CR>", mode = { "v" }, desc = "Move Block Down" },
  },
  opts = {
    -- Config here
  },
}

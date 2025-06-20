return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      "*",
    }, {
      names = false, -- Disable parsing "names" like Blue or Gray
    })
  end,
}

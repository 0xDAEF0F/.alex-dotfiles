vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out =
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("opts")
require("keymaps")

require("lazy").setup({
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme nordfox]])
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      auto_install = true,
      highlight = {
        enable = true,
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "rtneiohysvafumkljcpgdqxbz",
      label = {
        style = "overlay",
      },
      modes = {
        treesitter = {
          labels = "rtneiohysvafumkljcpgdqxbz",
        },
      },
      prompt = {
        enabled = false,
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = true })
      statusline.section_location = function()
        return "%2l:%-2v"
      end
      require("mini.pairs").setup()
      require("mini.completion").setup()
      require("mini.snippets").setup()
      require("mini.icons").setup()
      MiniIcons.tweak_lsp_kind()
    end,
  },
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    config = function()
      local lsp = require("lspconfig")
      -- Rust
      lsp.rust_analyzer.setup({
        settings = {
          ["rust-analyzer"] = {},
        },
      })
      -- Typescript
      lsp.ts_ls.setup({})
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sh", builtin.help_tags)
      vim.keymap.set("n", "<leader>sk", builtin.keymaps)
      vim.keymap.set("n", "<leader>sf", builtin.find_files)
      vim.keymap.set("n", "<leader>ss", builtin.builtin)
      vim.keymap.set("n", "<leader>sw", builtin.grep_string)
      vim.keymap.set("n", "<leader>sg", builtin.live_grep)
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics)
      vim.keymap.set("n", "<leader>sr", builtin.resume)
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles)
      vim.keymap.set("n", "<leader><leader>", builtin.buffers)

      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end)

      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end)
    end,
  }
})

return {
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
      defaults = {
        mappings = {
          n = {
            ["dd"] = require("telescope.actions").delete_buffer,
          },
        },
      },
    })

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    local builtin = require("telescope.builtin")

    -- most used (telescope)
    vim.keymap.set("n", "<leader>s.", builtin.oldfiles)
    vim.keymap.set("n", "<leader><leader>", builtin.buffers)
    vim.keymap.set("n", "<leader>sf", builtin.find_files)
    vim.keymap.set("n", "<leader>sw", builtin.grep_string)
    -- dont know the difference between these two
    vim.keymap.set("n", "<leader>sg", builtin.live_grep)
    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end)
    -- searches in neovim config
    vim.keymap.set("n", "<leader>sn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end)

    -- less used (telescope)
    vim.keymap.set("n", "<leader>sh", builtin.help_tags)
    vim.keymap.set("n", "<leader>sk", builtin.keymaps)
    vim.keymap.set("n", "<leader>ss", builtin.builtin)
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics)
    vim.keymap.set("n", "<leader>sr", builtin.resume)
  end,
  enabled = not vim.g.vscode,
}

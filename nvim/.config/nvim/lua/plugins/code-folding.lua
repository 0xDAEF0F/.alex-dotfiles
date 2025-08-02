-- https://github.com/jghauser/fold-cycle.nvim
return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local language_servers = vim.lsp.get_clients()
      for _, ls in ipairs(language_servers) do
        require("lspconfig")[ls].setup({
          capabilities = capabilities,
        })
      end
      require("ufo").setup({
        close_fold_kinds_for_ft = {
          default = { "imports" },
        },
        -- this is just to make the line a bit prettier (display how many lines folded)
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = (" 󰁂 %d "):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              -- str width returned from truncate() may less than 2nd argument, need padding
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, "MoreMsg" })
          return newVirtText
        end,
      })
    end,
  },
  {
    "jghauser/fold-cycle.nvim",
    config = function()
      require("fold-cycle").setup({
        open_if_max_closed = true,
        close_if_max_opened = true,
        softwrap_movement_fix = false,
      })
    end,
    init = function()
      vim.keymap.set("n", "<tab>", function()
        return require("fold-cycle").open()
      end, { silent = true, desc = "Fold-cycle: open folds" })
      vim.keymap.set("n", "<s-tab>", function()
        return require("fold-cycle").close()
      end, { silent = true, desc = "Fold-cycle: close folds" })
      vim.keymap.set("n", "zC", function()
        return require("fold-cycle").close_all()
      end, { remap = true, silent = true, desc = "Fold-cycle: close all folds" })
    end,
  },
}

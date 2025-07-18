return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Configure inlay hint appearance
    vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#888888", italic = true })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })

    vim.lsp.config("ts_ls", {
      settings = {
        diagnostics = {
          ignoredCodes = { 6133 }, -- unused variables (biome already warns)
        },
      },
    })

    -- Enable configured servers
    vim.lsp.enable("ts_ls")
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("biome")
    vim.lsp.enable("ruff")
    vim.lsp.enable("tailwindcss")
    vim.lsp.enable("gopls")
    vim.lsp.enable("prismals")

    -- Custom keymaps on LspAttach
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local opts = { buffer = event.buf }

        -- Enable file operations capabilities
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client then
          -- Ensure the client supports workspace/willRenameFiles
          client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities or {}, {
            workspace = {
              fileOperations = {
                willRename = true,
                didRename = true,
                willCreate = true,
                didCreate = true,
                willDelete = true,
                didDelete = true,
              },
            },
          })
        end

        -- Additional keymaps beyond defaults
        vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<leader>o", function()
          require("fzf-lua").lsp_references()
        end, opts)
        vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>v", require("fzf-lua").lsp_workspace_diagnostics, opts)

        -- Toggle inlay hints keybind
        vim.keymap.set("n", "<C-.>", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), nil)
        end)
      end,
    })
  end,
  enabled = not vim.g.vscode,
}

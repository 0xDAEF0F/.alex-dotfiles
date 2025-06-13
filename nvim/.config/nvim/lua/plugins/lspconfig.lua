return {
  -- Main LSP Configuration
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

    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
          check = {
            command = "clippy",
          },
          inlayHints = {
            bindingModeHints = {
              enable = true,
            },
            chainingHints = {
              enable = true,
            },
            closingBraceHints = {
              enable = true,
              minLines = 42,
            },
            closureReturnTypeHints = {
              enable = "always",
            },
            maxLength = 20,
            parameterHints = {
              enable = true,
            },
            renderColons = true,
            typeHints = {
              enable = true,
              hideClosureInitialization = false,
              hideNamedConstructor = false,
            },
          },
        },
      },
    })

    -- Enable configured servers
    vim.lsp.enable("rust_analyzer")
    vim.lsp.enable("ts_ls")
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("biome")
    vim.lsp.enable("ruff")

    -- Custom keymaps on LspAttach
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local opts = { buffer = event.buf }

        -- Enable inlay hints for this buffer
        vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

        -- Additional keymaps beyond defaults
        vim.keymap.set("n", "<leader>A", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>a", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, opts)
        -- vim.keymap.set("n", "<leader>n", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>n", "<cmd>Lspsaga hover_doc<CR>", opts)
        vim.keymap.set("n", "<leader>o", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, opts)
        -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)

        -- Toggle inlay hints keybind
        vim.keymap.set("n", "<leader>h", function()
          vim.lsp.inlay_hint.enable(
            not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
            { bufnr = event.buf }
          )
        end, { buffer = event.buf, desc = "Toggle inlay hints" })
      end,
    })
  end,
  enabled = not vim.g.vscode,
}

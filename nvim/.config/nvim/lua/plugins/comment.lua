return {
    'numToStr/Comment.nvim',
    opts = {
        toggler = {
            ---Line-comment toggle keymap
            line = '<leader>c',
        },
        mappings = {
            basic = false,
            extra = false,
        },
    },
    enabled = not vim.g.vscode
}

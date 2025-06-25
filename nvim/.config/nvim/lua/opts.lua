vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.timeoutlen = 400

if vim.g.vscode then
	vim.o.scrolloff = 0
	-- vscode only options
else
	vim.opt.termguicolors = true
	vim.opt.tabstop = 3 -- display 3 spaces per tab
	vim.opt.scrolloff = 14

	vim.opt.updatetime = 500

	vim.opt.number = true
	vim.opt.signcolumn = "yes"
	vim.opt.mouse = "a"
	vim.opt.showmode = false
	vim.opt.completeopt = "menuone,noinsert"

	vim.opt.splitright = true
	vim.opt.splitbelow = true

	vim.opt.foldlevel = 99
	vim.opt.foldlevelstart = 99

	-- blinking cursor
	vim.opt.guicursor =
		"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
end

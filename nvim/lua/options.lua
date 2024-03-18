vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

if not vim.g.vscode then
	-- this breaks in vscode for some reason
	vim.opt.inccommand = "nosplit"
end

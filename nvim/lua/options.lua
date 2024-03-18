vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.clipboard = "unnamedplus"
vim.cmd([[
autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=1000}
]])

if not vim.g.vscode then
	-- this breaks in vscode for some reason
	vim.opt.inccommand = "nosplit"
end

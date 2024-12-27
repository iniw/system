-- 4-spaces indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- ttimeout is really annoying
vim.opt.ttimeout = false

-- Disable the mouse
vim.opt.mouse = ""

-- Disable lsp logging, the file gets massive after a while
vim.lsp.set_log_level("off")

-- Disable snacks animations
vim.g.snacks_animate = false

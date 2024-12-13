vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- ttimeout is really annoying when paired with tmux
vim.opt.ttimeout = false

-- Disable root detection
vim.g.root_spec = { "cwd" }

vim.lsp.set_log_level("off")

-- Disable snacks animations
vim.g.snacks_animate = false

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- ttimeout is really annoying when paired with tmux
vim.opt.ttimeout = false

-- Disable root detection
vim.g.root_spec = { "cwd" }

vim.lsp.set_log_level("off")

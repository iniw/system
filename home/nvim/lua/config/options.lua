local o = vim.opt
local g = vim.g
local lsp = vim.lsp

-- Disable lsp logging, the file gets massive after a while
lsp.set_log_level("off")

g.mapleader = " "
g.maplocalleader = "\\"
-- Fix markdown indentation settings
g.markdown_recommended_style = 0

o.shiftwidth = 4
o.tabstop = 4
o.expandtab = true
o.mouse = "a"
o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
o.autowrite = true
o.completeopt = "menu,menuone,noselect"
o.confirm = true
o.conceallevel = 2
o.cursorline = true
o.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
o.foldlevel = 99
o.grepformat = "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep"
o.ignorecase = true
o.inccommand = "nosplit"
o.jumpoptions = "view"
o.linebreak = true
o.list = true
o.number = true
o.relativenumber = true
o.pumheight = 10
o.scrolloff = 4
o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
o.shiftround = true
o.shortmess:append({ W = true, I = true, c = true, C = true })
o.sidescrolloff = 8
o.signcolumn = "yes"
o.smartcase = true
o.smartindent = true
o.splitright = true
o.splitbelow = true
o.splitkeep = "screen"
o.termguicolors = true
o.timeoutlen = 300
o.undofile = true
o.undolevels = 10000
o.updatetime = 200
o.virtualedit = "block"
o.wildmode = "longest:full,full"
o.winminwidth = 5
o.wrap = false
o.smoothscroll = true
o.foldtext = ""

-- Status line
o.laststatus = 3
o.cmdheight = 0
o.statusline = [[ %{expand("%:~:.")} %m %r %w%=%l:%c ]]

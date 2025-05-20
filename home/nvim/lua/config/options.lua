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
o.completeopt = { "menu", "menuone", "noselect" }
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
o.ttimeoutlen = 0
o.timeoutlen = 300
o.undofile = true
o.undolevels = 10000
o.updatetime = 200
o.virtualedit = "block"
o.wildmode = { "longest:full", "full" }
o.winminwidth = 5
o.wrap = false
o.smoothscroll = true
o.guicursor = { "n-v-c-sm:block", "i-ci-ve:ver25", "r-cr-o:hor20" }
o.spelllang = ""

-- Status line
o.laststatus = 3
o.statusline = [[ %{v:lua.StatusLineLeft()}%=%{v:lua.StatusLineRight()} ]]

o.cmdheight = 0

local function concat(elements)
  local filtered = vim.tbl_filter(function(s) return s ~= "" end, elements)
  return table.concat(filtered, " ")
end

function StatusLineLeft()
  if vim.bo.buftype == "terminal" then
    return ""
  end

  local function Filename() return vim.fn.expand("%:~:.") end
  local function Modified() return vim.bo.modified and "[+]" or (vim.bo.modifiable and "" or "[-]") end
  local function ReadOnly() return vim.bo.readonly and "[RO]" or "" end

  return concat({
    Filename(),
    Modified(),
    ReadOnly(),
  })
end

function StatusLineRight()
  local function LineInfo()
    local cursorpos = vim.fn.getpos(".")
    return string.format("%s:%s", cursorpos[2], cursorpos[3])
  end

  local function VisualSelectionInfo()
    if vim.fn.mode():find("[vV]") then
      local wc = vim.fn.wordcount()
      local start_line = vim.fn.line("v")
      local end_line = vim.fn.line(".")
      local line_count = math.abs(end_line - start_line) + 1
      return string.format("[%d:%d]", line_count, wc.visual_chars)
    else
      return ""
    end
  end

  return concat({
    LineInfo(),
    VisualSelectionInfo(),
  })
end

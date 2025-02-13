-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "help",
    "lspinfo",
    "gitsigns-blame",
    "notify",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- Vim automatically changes `formatoptions` depending on the detected filetype, inserting the nasty "o" flag.
-- That behavior is unmodifiable, so we have to override the option with an autocmd.
-- See also: https://github.com/neovim/neovim/discussions/26908
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function() vim.opt.formatoptions = "tcqjrln" end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function() vim.opt_local.indentkeys:remove(":") end,
})

vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function() vim.opt.cmdheight = 1 end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function() vim.opt.cmdheight = 0 end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
})

-- Make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "man" },
  callback = function(event) vim.bo[event.buf].buflisted = false end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json", "jsonc", "json5" },
  callback = function() vim.opt_local.conceallevel = 0 end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

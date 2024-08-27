-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "<C-o>", "<Left><C-o>")
vim.keymap.set("n", "gad", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>")

-- Quick jump to the Nth window/tab
for i = 1, 6 do
  local m = { "n", "i" }
  vim.keymap.set(m, "<leader>" .. i, i .. "<C-w>w", { desc = "Move to window " .. i })
  vim.keymap.set(m, "<leader><tab>" .. i, i .. "gt", { desc = "Move to tab " .. i })
end

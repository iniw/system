-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Quick jump to the Nth window/tab
for i = 1, 6 do
  vim.keymap.set("n", "<leader>" .. i, i .. "<C-w>w", { desc = "Move to window " .. i })
  vim.keymap.set("n", "<leader><tab>" .. i, i .. "gt", { desc = "Move to tab " .. i })
end

vim.keymap.set("i", "<C-o>", "<Left><C-o>")

vim.keymap.del("n", "<C-Up>")
vim.keymap.del("n", "<C-Down>")
vim.keymap.del("n", "<C-Left>")
vim.keymap.del("n", "<C-Right>")

vim.keymap.set("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

require("lazyvim.util").toggle.map("<leader>ua", {
  name = "Autocomplete",
  get = function()
    return vim.g.autocomplete_enabled
  end,
  set = function(state)
    vim.g.autocomplete_enabled = state
  end,
})

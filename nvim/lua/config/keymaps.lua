-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Open definition in new window
vim.keymap.set("n", "gad", function()
  require("telescope.builtin").lsp_definitions({
    jump_type = "vsplit",
    attach_mappings = function(_, map)
      map({ "n", "i" }, "<CR>", require("telescope.actions").select_vertical)
      return true
    end,
  })
end, { noremap = true, silent = true, desc = "Go to definition in a new window" })

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

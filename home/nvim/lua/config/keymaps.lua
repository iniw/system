-- Quick jump to the Nth window/tab
for i = 1, 6 do
  vim.keymap.set("n", "<leader>" .. i, i .. "<C-w>w", { desc = "Move to window " .. i })
  vim.keymap.set("n", "<leader><tab>" .. i, i .. "gt", { desc = "Move to tab " .. i })
end

vim.keymap.set("i", "<C-o>", "<Left><C-o>")

vim.keymap.set("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

vim.keymap.set("n", "D", "dd")
vim.keymap.set("n", "Y", "yy")
vim.keymap.set("n", "C", "cc")

Snacks.toggle
  .new({
    name = "Autocomplete",
    get = function()
      return vim.g.autocomplete_enabled
    end,
    set = function(state)
      vim.g.autocomplete_enabled = state
    end,
  })
  :map("<leader>ua")

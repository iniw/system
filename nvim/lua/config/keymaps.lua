-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "<C-o>", "<Left><C-o>")

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
  vim.keymap.set({ "n", "i" }, "<leader>" .. i, i .. "<C-w>w", { desc = "Move to window " .. i })
  vim.keymap.set({ "n", "i" }, "<leader><tab>" .. i, i .. "gt", { desc = "Move to tab " .. i })
end

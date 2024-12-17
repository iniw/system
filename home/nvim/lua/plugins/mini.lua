return {
  {
    "echasnovski/mini.ai",
    vscode = true,
    opts = {
      search_method = "cover",
    },
  },

  {
    "echasnovski/mini.jump",
    vscode = true,
    opts = {},
  },

  {
    "echasnovski/mini.surround",
    vscode = true,
    init = function()
      -- https://github.com/echasnovski/mini.nvim/blob/57e47cf7a2923684e7413989ab267ed9730e7d03/doc/mini-surround.txt#L570
      vim.keymap.set({ "n", "v" }, "s", "<Nop>")
    end,
    opts = {
      silent = true,
    },
  },
}

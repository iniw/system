local shared = require("shared")

return {
  {
    "ibhagwan/fzf-lua",
    opts = {
      fzf_colors = {
        ["hl"] = shared.colors.primary,
        ["hl+"] = shared.colors.secondary,
      },
    },
    keys = {
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    },
  },
}

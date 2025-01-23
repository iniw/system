---@module "various-textobjs"

---@type LazySpec
return {
  {
    "chrisgrieser/nvim-various-textobjs",
    vscode = true,
    event = "VeryLazy",
    ---@type VariousTextobjs.Config
    opts = {
      keymaps = {
        useDefaults = true,
      },
    },
  },
}

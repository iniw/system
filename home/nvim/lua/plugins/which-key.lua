---@module "which-key"

---@type LazySpec
return {
  {
    "folke/which-key.nvim",
    ---@type wk.Config
    opts = {
      preset = "modern",
    },
  },
}

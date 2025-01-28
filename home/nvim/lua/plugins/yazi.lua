---@module "yazi"
---@module "plenary"
---@module "which-key"

---@type LazySpec
return {
  {
    "mikavilpas/yazi.nvim",
    lazy = true,
    keys = {
      {
        "<leader>yy",
        "<cmd>Yazi<cr>",
        desc = "Open yazi (Directory of Current File)",
        mode = { "n", "v" },
      },
      {
        "<leader>yY",
        "<cmd>Yazi cwd<cr>",
        desc = "Open yazi (cwd)",
        mode = { "n", "v" },
      },
      {
        "<leader>yR",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume",
        mode = { "n", "v" },
      },
    },
    ---@type YaziConfig
    opts = {
      integrations = {
        grep_in_directory = "snacks.picker",
        grep_in_selected_files = "snacks.picker",
        resolve_relative_path_application = "realpath",
      },
    },
  },

  {
    "folke/which-key.nvim",
    ---@type wk.Config
    opts = {
      spec = {
        {
          { "<leader>y", group = "yazi", icon = { icon = " ", color = "blue" } },
        },
      },
    },
  },
}

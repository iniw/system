return {
  {
    "mikavilpas/yazi.nvim",
    lazy = true,
    version = "*",
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
    opts = {
      integrations = {
        resolve_relative_path_application = "realpath",
        grep_in_selected_files = "fzf-lua",
        grep_in_directory = "fzf-lua",
      },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          { "<leader>y", group = "yazi", icon = { icon = " ", color = "blue" } },
        },
      },
    },
  },
}

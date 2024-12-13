return {
  {
    "mikavilpas/yazi.nvim",
    lazy = true,
    keys = {
      {
        "<leader>yy",
        "<cmd>Yazi<cr>",
        desc = "Open yazi (Directory of Current File)",
      },
      {
        "<leader>yY",
        "<cmd>Yazi cwd<cr>",
        desc = "Open yazi (cwd)",
      },
      {
        "<leader>yR",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume",
      },
    },
    opts = {
      integrations = {
        resolve_relative_path_application = "realpath",
      },
    },
  },
}

return {
  {
    "mikavilpas/yazi.nvim",
    lazy = true,
    keys = {
      {
        "<leader>yy",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>yw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<leader>yR",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },

    opts = {
      integrations = {
        resolve_relative_path_application = "realpath",
      },
    },
  },
}

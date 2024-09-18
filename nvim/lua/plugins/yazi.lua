return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
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
      open_for_directories = true,
      integrations = {
        resolve_relative_path_application = "realpath",
      },
    },
  },
}

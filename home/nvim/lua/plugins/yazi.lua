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
        grep_in_directory = function(directory)
          Snacks.picker.grep({ dirs = { directory } })
        end,
        grep_in_selected_files = function(selected_files)
          local files = {}
          for _, path in ipairs(selected_files) do
            files[#files + 1] = path:make_relative(vim.uv.cwd()):gsub(" ", "\\ ")
          end

          Snacks.picker.grep({ dirs = files })
        end,

        resolve_relative_path_application = "realpath",
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

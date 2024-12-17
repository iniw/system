return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c = {
        LazyVim.lualine.root_dir(),
        LazyVim.lualine.pretty_path(),
      }

      opts.sections.lualine_x = {}
      opts.sections.lualine_z = {}
    end,
  },
}

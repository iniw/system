local palette = {
  primary = "#73b3e7",
  secondary = "#c5d8e8",
}

return {
  {
    "jesseleite/nvim-noirbuddy",
    dependencies = { "tjdevries/colorbuddy.nvim" },
    lazy = false,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("noirbuddy").setup({
          colors = {
            primary = palette.primary,
          },
        })

        local cb = require("colorbuddy")

        local Group = cb.Group
        local Color = cb.Color
        local colors = cb.colors

        Color.new("bracket", palette.secondary)

        Group.new("@operator", colors.primary)
        Group.new("@punctuation.bracket", colors.bracket)
        -- "`noir_0` is light for dark themes, and dark for light themes".
        Group.new("@lsp.type.method", colors.noir_0)
      end,
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.theme = require("noirbuddy.plugins.lualine").theme
    end,
  },

  {
    "ibhagwan/fzf-lua",
    opts = {
      fzf_colors = {
        ["hl"] = palette.primary,
        ["hl+"] = palette.secondary,
      },
    },
  },
}

local palette = {
  primary = "#73b3e7",
  primary_light = "#c5d8e8",
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

        cb.Color.new("primary_light", palette.primary_light)

        -- Slightly off-white text
        cb.Group.new("Normal", cb.colors.secondary)
        cb.Group.new("NormalFloat", cb.colors.secondary)

        -- White methods
        cb.Group.new("@method", cb.colors.noir_0)
        cb.Group.new("@lsp.type.method", cb.colors.noir_0)

        -- Blue punctuation and operators
        cb.Group.new("@operator", cb.colors.primary)
        cb.Group.new("@punctuation.bracket", cb.colors.primary_light)

        -- Blue highlight on the picker
        cb.Group.new("SnacksPickerMatch", cb.colors.primary)
      end,
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.theme = require("noirbuddy.plugins.lualine").theme
    end,
  },
}

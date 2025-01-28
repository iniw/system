local palette = {
  primary = "#73b3e7",
  primary_light = "#c5d8e8",
}

---@type LazySpec
return {
  {
    "jesseleite/nvim-noirbuddy",
    dependencies = { { "tjdevries/colorbuddy.nvim", version = false } },
  },

  {
    "LazyVim/LazyVim",
    ---@type LazyVimOptions
    opts = {
      colorscheme = function()
        require("noirbuddy").setup({
          colors = {
            primary = palette.primary,
          },
        })

        local cb = require("colorbuddy")

        cb.Color.new("primary_light", palette.primary_light)

        -- Slightly brighter text
        cb.Group.new("Normal", cb.colors.secondary)
        cb.Group.new("NormalFloat", cb.colors.secondary)

        -- White methods
        cb.Group.new("@method", cb.colors.white)
        cb.Group.new("@lsp.type.method", cb.colors.white)

        -- More highlights here and there
        cb.Group.new("SnacksPickerMatch", cb.colors.primary)
        cb.Group.new("@operator", cb.colors.primary)
        cb.Group.new("@punctuation.bracket", cb.colors.primary_light)

        -- Slightly brighter NonText, which is usually used for dimmed stuff
        cb.Group.new("NonText", cb.groups.Comment)
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

local shared = require("shared")

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("noirbuddy").setup({
          colors = {
            primary = shared.colors.primary,
          },
        })

        local cb = require("colorbuddy")

        local Group = cb.Group
        local Color = cb.Color
        local colors = cb.colors

        Color.new("bracket", shared.colors.secondary)

        Group.new("@operator", colors.primary)
        Group.new("@punctuation.bracket", colors.bracket)
        -- "`noir_0` is light for dark themes, and dark for light themes".
        Group.new("@lsp.type.method", colors.noir_0)
      end,
    },
  },
}

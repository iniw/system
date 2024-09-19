return {
  {
    "hrsh7th/nvim-cmp",
    init = function()
      vim.g.autocomplete_enabled = false
    end,
    opts = {
      enabled = function()
        return vim.g.autocomplete_enabled
      end,
    },
  },
}

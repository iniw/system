return {
  {
    "snacks.nvim",
    opts = function(_, opts)
      -- Remove the delay before updating
      opts.words.debounce = 25

      -- Remove the header/footer
      opts.dashboard.sections = {
        { section = "keys", gap = 1, padding = 1 },
      }
    end,
  },
}

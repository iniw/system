return {
  {
    "snacks.nvim",
    opts = function(_, opts)
      opts.dashboard.sections = {
        { section = "keys", gap = 1, padding = 1 },
      }
    end,
  },
}

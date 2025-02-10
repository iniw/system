---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find file", action = ":lua Snacks.picker.files()" },
            { icon = " ", key = "g", desc = "Find text", action = ":lua Snacks.picker.grep()" },
            { icon = " ", key = "s", desc = "Restore session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "keys", gap = 1 },
        },
      },

      input = {
        enabled = true,
      },

      notifier = {
        enabled = true,
      },
    },
  },

  {
    "echasnovski/mini.icons",
    opts = {},
  },
}

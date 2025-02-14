---@type LazySpec
return {
  -- Colorscheme
  {
    "jesseleite/nvim-noirbuddy",
    priority = 2000,
    lazy = false,
    dependencies = { { "tjdevries/colorbuddy.nvim", version = false } },
    config = function()
      local palette = {
        primary = "#73b3e7",
        primary_light = "#c5d8e8",
      }

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
    "folke/noice.nvim",
    lazy = false,
    dependencies = "MunifTanjim/nui.nvim",
    ---@module "noice"
    ---@type NoiceConfig
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },

        signature = {
          enabled = false,
        },
      },

      presets = {
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },

  {
    "echasnovski/mini.icons",
    opts = {},
  },
}

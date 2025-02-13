---@type LazySpec
return {
  {
    "jake-stewart/multicursor.nvim",
    config = function()
      local function hl(group, definition) vim.api.nvim_set_hl(0, group, { link = definition }) end

      hl("MultiCursorCursor", "TodoBgFIX")
      hl("MultiCursorSign", "TodoSignFIX")
      hl("MultiCursorDisabledCursor", "TodoBgNOTE")
      hl("MultiCursorDisabledSign", "TodoSignNOTE")

      require("multicursor-nvim").setup()
    end,
  },

  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      search = {
        multi_window = false,
      },

      modes = {
        char = {
          -- mini.jump is used for this instead.
          enabled = false,
        },
      },
    },
    keys = {
      {
        "<cr>",
        function() require("flash").jump() end,
        mode = { "n", "o", "v" },
      },
    },
  },

  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      terminal = {
        enabled = true,

        win = {
          wo = {
            winbar = "",
          },
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    ---@type TSConfig
    opts = {
      textobjects = {
        select = {
          enable = true,

          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
          },
        },

        move = {
          enable = true,

          goto_next_start = {
            ["]f"] = "@function.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
          },
        },
      },
    },
  },

  {
    "chrisgrieser/nvim-various-textobjs",
    event = sol.OnFile,
    ---@module "various-textobjs"
    ---@type VariousTextobjs.Config
    opts = {
      keymaps = {
        useDefaults = true,
      },
    },
  },

  {
    "echasnovski/mini.ai",
    event = sol.OnFile,
    opts = {
      silent = true,
      search_method = "cover",
    },
  },

  {
    "echasnovski/mini.surround",
    event = sol.OnFile,
    init = function()
      -- https://github.com/echasnovski/mini.nvim/blob/57e47cf7a2923684e7413989ab267ed9730e7d03/doc/mini-surround.txt#L570
      vim.keymap.set({ "n", "v" }, "s", "<Nop>")
    end,
    opts = { silent = true },
  },

  {
    "echasnovski/mini.jump",
    event = sol.OnFile,
    opts = { silent = true },
  },

  {
    "echasnovski/mini.move",
    event = sol.OnFile,
    opts = {
      -- Use wasd instead of hjkl to avoid moving lines around when quickly pressing esc+{motion}
      mappings = {
        left = "<a-a>",
        right = "<a-d>",
        down = "<a-s>",
        up = "<a-w>",

        line_left = "<a-a>",
        line_right = "<a-d>",
        line_down = "<a-s>",
        line_up = "<a-w>",
      },
    },
  },

  {
    "echasnovski/mini.comment",
    event = sol.OnFile,
    opts = {},
  },
}

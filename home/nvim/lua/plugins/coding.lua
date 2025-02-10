---@type LazySpec
return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      format_on_save = function(buf)
        if vim.g.autoformat ~= false and vim.b[buf].autoformat ~= false then
          return { timeout_ms = 3000, lsp_format = "fallback" }
        end
      end,
    },
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true }) end,
        desc = "Format buffer",
      },
      {
        "<c-s>",
        "<cmd>w<cr>",
        desc = "Save Buffer",
        mode = { "n", "i" },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      Snacks.toggle({
        name = "autoformat (buffer)",
        get = function() return vim.b.autoformat ~= false end,
        set = function(state) vim.b.autoformat = state end,
      }):map("<leader>uf")

      Snacks.toggle({
        name = "autoformat (global)",
        get = function() return vim.g.autoformat ~= false end,
        set = function(state) vim.g.autoformat = state end,
      }):map("<leader>uF")

      vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
    end,
  },

  {
    "jake-stewart/multicursor.nvim",
    config = function()
      local function hl(group, definition) vim.api.nvim_set_hl(0, group, { link = definition }) end

      hl("MultiCursorCursor", "TodoBgFIX")
      hl("MultiCursorSign", "TodoSignFIX")

      require("multicursor-nvim").setup()
    end,
    keys = {},
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
    event = { "BufRead", "BufNewFile" },
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
    event = { "BufRead", "BufNewFile" },
    opts = {
      silent = true,
      search_method = "cover",
    },
  },

  {
    "echasnovski/mini.surround",
    event = { "BufRead", "BufNewFile" },
    init = function()
      -- https://github.com/echasnovski/mini.nvim/blob/57e47cf7a2923684e7413989ab267ed9730e7d03/doc/mini-surround.txt#L570
      vim.keymap.set({ "n", "v" }, "s", "<Nop>")
    end,
    opts = { silent = true },
  },

  {
    "echasnovski/mini.jump",
    event = { "BufRead", "BufNewFile" },
    opts = { silent = true },
  },

  {
    "echasnovski/mini.move",
    event = { "BufRead", "BufNewFile" },
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
    event = { "BufRead", "BufNewFile" },
    opts = {},
  },
}

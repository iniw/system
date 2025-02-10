---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
      bigfile = {
        enabled = true,
      },

      indent = {
        enabled = true,
        animate = {
          enabled = false,
        },
        scope = {
          only_current = true,
        },
      },

      statuscolumn = {
        enabled = true,
        left = { "sign" },
      },

      words = {
        debounce = 25,
      },
    },
    keys = {
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous reference", mode = { "n", "t" } },
    },
  },

  -- Explorer
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      explorer = {
        replace_netrw = true,
      },

      picker = {
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  ["<c-t>"] = { { "tab", "tcd" } },
                },
              },
            },
            layout = {
              layout = {
                position = "right",
              },
            },
          },
        },
      },
    },
  },

  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", version = false },
    },
    ---@module "yazi"
    ---@type YaziConfig
    opts = {
      integrations = {
        grep_in_directory = "snacks.picker",
        grep_in_selected_files = "snacks.picker",
        resolve_relative_path_application = "realpath",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    lazy = false,
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
  },

  {
    "folke/which-key.nvim",
    lazy = false,
    ---@type wk.Config
    opts = {
      icons = {
        mappings = false,
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = { "BufRead", "BufNewFile" },
    opts = {
      highlight = {
        keyword = "wide_fg",
        -- Don't highlight the actual comment text, just the keyword.
        after = "",
      },
    },
  },

  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {},
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },

  {
    "tpope/vim-sleuth",
    version = false,
    event = { "BufRead", "BufNewFile" },
  },
}

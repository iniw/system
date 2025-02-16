---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module "snacks"
    ---@type snacks.Config
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

        folds = {
          open = true,
        },

        left = { "sign" },
      },
    },
  },

  -- Explorer
  {
    "folke/snacks.nvim",
    ---@module "snacks"
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
    priority = 3000,
    version = false,
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    lazy = false,
    ---@module "nvim-treesitter"
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
    },
    init = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldtext = ""
    end,
  },

  {
    "folke/which-key.nvim",
    lazy = false,
    ---@module "which-key"
    ---@type wk.Config
    opts = {
      icons = {
        mappings = false,
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = sol.OnFile,
    ---@module "todo-comments"
    ---@type TodoOptions
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
    ---@module "grug-far"
    ---@type GrugFarOptions
    opts = {},
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    ---@module "persistence"
    ---@type Persistence.Config
    opts = {},
  },

  {
    "tpope/vim-sleuth",
    version = false,
    event = sol.OnFile,
  },
}

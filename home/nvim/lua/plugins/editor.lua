---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    priority = 3000,
    version = false,
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    lazy = false,
    ---@module "nvim-treesitter"
    ---@type TSConfig
    opts = {
      highlight = {
        enable = true,
      },

      indent = {
        enable = true,
      },

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
    init = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldtext = ""
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      explorer = {
        replace_netrw = true,
      },

      indent = {
        enabled = true,

        animate = {
          enabled = false,
        },
      },

      picker = {
        sources = {
          notifications = {
            win = {
              preview = {
                wo = {
                  wrap = true,
                },
              },
            },
          },
        },
      },

      statuscolumn = {
        enabled = true,

        folds = {
          open = true,
        },

        left = { "sign" },
        right = { "git", "fold" },
      },

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
    "folke/flash.nvim",
    ---@module "flash"
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
  },

  {
    "folke/which-key.nvim",
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

      signs = false,
    },
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    ---@module "persistence"
    ---@type Persistence.Config
    opts = {},
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
    "jake-stewart/multicursor.nvim",
    ---@module "multicursor-nvim"
    ---@type mc.MultiCursorOpts
    opts = {},
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
    "echasnovski/mini.ai",
    event = sol.OnFile,
    opts = {
      silent = true,
      search_method = "cover",
      n_lines = 200,
    },
  },

  {
    "echasnovski/mini.surround",
    event = sol.OnFile,
    init = function()
      -- https://github.com/echasnovski/mini.nvim/blob/57e47cf7a2923684e7413989ab267ed9730e7d03/doc/mini-surround.txt#L570
      vim.keymap.set({ "n", "v" }, "s", "<nop>")
    end,
    opts = {
      silent = true,
    },
  },

  {
    "echasnovski/mini.jump",
    event = sol.OnFile,
    opts = {
      delay = {
        highlight = 0,
      },
      silent = true,
    },
  },

  {
    "echasnovski/mini.move",
    event = sol.OnFile,
    opts = {},
  },

  {
    "echasnovski/mini.comment",
    event = sol.OnFile,
    opts = {},
  },

  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    ---@module "grug-far"
    ---@type grug.far.Options
    opts = {},
  },

  {
    "tpope/vim-sleuth",
    version = false,
    event = sol.OnFile,
  },

  {
    "tpope/vim-fugitive",
    version = false,
    cmd = { "Git", "G" },
  },

  {
    "stevearc/oil.nvim",
    version = false,
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,

      constrain_cursor = "name",

      skip_confirm_for_simple_edits = true,

      lsp_file_methods = {
        autosave_changes = true,
      },

      use_default_keymaps = false,
      keymaps = {
        ["H"] = "actions.parent",
        ["L"] = "actions.select",
        ["R"] = "actions.open_cwd",
        ["gx"] = "actions.open_external",
        ["<cr>"] = "actions.select",
        ["<c-y>"] = "actions.yank_entry",
        ["<c-r>"] = "actions.refresh",
        ["<c-q>"] = "actions.send_to_qflist",
        ["<c-v>"] = { "actions.select", opts = { vertical = true } },
        ["<a-h>"] = "actions.toggle_hidden",
        ["?"] = "actions.show_help",
        ["<leader>;"] = {
          "actions.open_cmdline",
          desc = "Open the command line with the current file as an argument",
        },
        ["<leader>:"] = {
          "actions.open_cmdline",
          opts = {
            modify = ":h",
          },
          desc = "Open the command line with the current directory as an argument",
        },
      },

      view_options = {
        show_hidden = true,
      },

      watch_for_changes = true,
    },
  },
}

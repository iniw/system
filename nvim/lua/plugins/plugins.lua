-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
local primary = "#ff265c"
local secondary = "#ffdbe8"
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("noirbuddy").setup({
          colors = {
            primary = primary,
          },
        })

        local cb = require("colorbuddy")

        local Group = cb.Group
        local Color = cb.Color
        local colors = cb.colors

        Color.new("bracket", secondary)

        Group.new("@operator", colors.primary)
        Group.new("@punctuation.bracket", colors.bracket)
        -- "`noir_0` is light for dark themes, and dark for light themes".
        Group.new("@lsp.type.method", colors.noir_0)
      end,
    },
  },

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

  {
    "williamboman/mason.nvim",
    opts = {
      -- Prefer to use the native tools if they're installed.
      PATH = "append",
    },
  },

  {
    "jesseleite/nvim-noirbuddy",
    dependencies = { { "tjdevries/colorbuddy.nvim" } },
    lazy = false,
  },

  {
    "nvim-lualine/lualine.nvim",
    -- Based on the snippet at: https://www.lazyvim.org/plugins/ui#lualinenvim
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            LazyVim.lualine.root_dir(),
            { LazyVim.lualine.pretty_path() },
          },
          lualine_x = {},
          lualine_y = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = function() return LazyVim.ui.fg("Statement") end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = function() return LazyVim.ui.fg("Constant") end,
            },
          },
          lualine_z = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
        },
        extensions = { "neo-tree" },
      }

      return opts
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--query-driver=**",
            "--header-insertion=never",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--clang-tidy",
            "--background-index",
          },
          keys = {
            {
              "<leader>ch",
              "<cmd>ClangdSwitchSourceHeader<cr>",
              desc = "Switch Source/Header (C/C++)",
            },
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          -- Fixes offset-related warnings when opening some c++ files
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,

        -- rustaceanvim takes care of rust-analyzer
        rust_analyzer = function()
          return true
        end,
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    init = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              files = {
                excludeDirs = {
                  -- Exclude these directories otherwise ra gets utterly demolished attempting to analyze the entirety of nixpkgs.
                  ".direnv/",
                  ".git/",
                  ".github/",
                },
              },
            },
          },
        },
      }
    end,
  },

  {
    "folke/flash.nvim",
    vscode = true,
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
    -- Override LazyVim's default keymaps.
    keys = function()
      return {
        {
          "<CR>",
          mode = { "n", "o", "v" },
          function()
            require("flash").jump()
          end,
        },
      }
    end,
  },

  {
    "folke/noice.nvim",
    opts = {
      routes = {
        {
          -- jdtls' progress notifications are *extremely* spammy, the two "Validate" and "Publish" mentioned in this function in particular
          -- happen about twice for every character typed!
          -- I couldn't figure out a way to filter the lsp events themselves so this just filters the actual rendering of the notifications.
          filter = {
            event = "lsp",
            kind = "progress",
            cond = function(message)
              local client = vim.tbl_get(message.opts, "progress", "client")
              if client ~= "jdtls" then
                return false
              end

              local content = vim.tbl_get(message.opts, "progress", "message")
              if content == nil then
                return false
              end

              return string.find(content, "Validate") or string.find(content, "Publish")
            end,
          },
          opts = { skip = true },
        },
      },
    },
  },

  {
    "chrisgrieser/nvim-various-textobjs",
    vscode = true,
    opts = {
      useDefaultKeymaps = true,
    },
  },

  {
    "echasnovski/mini.ai",
    vscode = true,
    opts = {},
  },

  {
    "echasnovski/mini.jump",
    vscode = true,
    opts = {},
  },

  {
    "echasnovski/mini.surround",
    vscode = true,
    init = function()
      -- https://github.com/echasnovski/mini.nvim/blob/57e47cf7a2923684e7413989ab267ed9730e7d03/doc/mini-surround.txt#L570
      vim.keymap.set({ "n", "v" }, "s", "<Nop>")
    end,
    opts = {
      silent = true,
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "gad",
        function()
          require("telescope.builtin").lsp_definitions({
            jump_type = "vsplit",
            attach_mappings = function(_, map)
              map({ "n", "i" }, "<CR>", require("telescope.actions").select_vertical)
              return true
            end,
          })
        end,
        desc = "Go to definition in a new window",
      },
    },
  },

  {
    "ibhagwan/fzf-lua",
    opts = {
      fzf_colors = {
        ["hl"] = primary,
        ["hl+"] = secondary,
      },
    },
    keys = {
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    },
  },

  {
    "mg979/vim-visual-multi",
    init = function()
      vim.g.VM_theme = "neon"
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = { position = "right" },
    },
  },

  "tpope/vim-sleuth",
}

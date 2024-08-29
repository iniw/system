-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        local primary = "#ff265c"
        local secondary = "#ffdbe8"

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
    opts = {
      completion = {
        autocomplete = false,
      },
      mapping = {
        ["<C-Space>"] = require("cmp").mapping.complete(),
      },
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
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        clangd = {
          keys = {
            {
              "<leader>ch",
              "<cmd>ClangdSwitchSourceHeader<cr>",
              desc = "Switch Source/Header (C/C++)",
            },
          },
        },
      },
    },
    setup = {
      clangd = function(_, opts)
        -- Fixes some offset-related warnings when opening some c++ files
        opts.capabilities.offsetEncoding = { "utf-16" }
      end,
    },
  },

  {
    "folke/flash.nvim",
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
    -- FIXME(zellij_flicker): Remove once https://github.com/folke/noice.nvim/commit/1698725a663aca56bcd07a0e405bc441a5f6613b is reverted/fixed.
    -- Context: https://github.com/folke/noice.nvim/issues/923
    version = "4.4.7",
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
    "klen/nvim-config-local",
    opts = {
      config_files = { ".nvim/local.lua" },
    },
  },

  {
    "chrisgrieser/nvim-various-textobjs",
    opts = {
      useDefaultKeymaps = true,
    },
  },

  {
    "echasnovski/mini.ai",
    opts = {},
  },

  {
    "echasnovski/mini.jump",
    opts = {},
  },

  {
    "echasnovski/mini.surround",
    init = function()
      -- https://github.com/echasnovski/mini.nvim/blob/57e47cf7a2923684e7413989ab267ed9730e7d03/doc/mini-surround.txt#L570
      vim.keymap.set({ "n", "v" }, "s", "<Nop>")
    end,
    opts = {
      silent = true,
    },
  },

  "mg979/vim-visual-multi",
}

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
          enabled = false,
        },
      },
    },
    -- Override LazyVim's  default flash keymaps
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
    config = true,
  },

  {
    "echasnovski/mini.jump",
    config = true,
  },

  {
    "echasnovski/mini.surround",
    opts = {
      silent = true,
    },
  },

  "mg979/vim-visual-multi",
}

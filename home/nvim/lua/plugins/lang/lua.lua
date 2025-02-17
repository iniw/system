---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              -- Disable snippets
              -- From: https://cmp.saghen.dev/configuration/snippets#disable-all-snippets
              completion = {
                callSnippet = "Disable",
                keywordSnippet = "Disable",
              },
            },
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks", "snacks" } },
        { path = "lazy.nvim", words = { "LazySpec" } },
      },
    },
  },

  {
    "saghen/blink.cmp",
    --- @module "blink.cmp"
    --- @type blink.cmp.Config
    opts = {
      sources = {
        default = { "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },
    },
  },
}

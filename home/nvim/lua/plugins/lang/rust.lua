---@type LazySpec
return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    ---@module "rustaceanvim"
    ---@type rustaceanvim.Opts
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            -- Disable snippets
            -- From: https://cmp.saghen.dev/configuration/snippets#disable-all-snippets
            completion = {
              capable = {
                snippets = "add_parenthesis",
              },
            },

            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },

            files = {
              excludeDirs = {
                ".direnv",
                ".git",
                ".github",
                "target",
              },
            },
          },
        },
      },
    },
    config = function(_, opts) vim.g.rustaceanvim = opts end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },

  {
    "Saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    ---@module "crates"
    ---@type crates.UserConfig
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
}

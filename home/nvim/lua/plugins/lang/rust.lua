---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                allTargets = false,
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
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Prefer LSP format to respect the project's edition.
        rust = { "rustfmt", lsp_format = "prefer" },
      },
    },
  },
}

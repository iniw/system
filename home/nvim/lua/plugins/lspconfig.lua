return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },

      servers = {
        jdtls = {},
        clangd = {
          cmd = {
            "clangd",
            "--query-driver=/**/*",
            "--header-insertion=never",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--clang-tidy",
            "--background-index",
          },
        },
      },

      setup = {
        -- rustaceanvim takes care of rust-analyzer
        rust_analyzer = function()
          return true
        end,

        -- nvim-jdtls takes care of jdtls
        jdtls = function()
          return true
        end,
      },
    },
  },
}

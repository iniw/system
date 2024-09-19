return {
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
}

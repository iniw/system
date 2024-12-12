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
            "--query-driver=/**/*",
            "--header-insertion=never",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--clang-tidy",
            "--background-index",
          },
        },
      },
    },
  },
}

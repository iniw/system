---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          keys = {
            {
              "<leader>cm",
              "<cmd>MarkdownPreviewToggle<cr>",
              desc = "Markdown preview",
            },
          },
        },
      },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    version = false,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = "markdown",
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    config = function() vim.cmd("do FileType") end,
  },
}

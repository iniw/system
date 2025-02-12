---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          keys = {
            { "<leader>cm", group = "markdown" },
            {
              "<leader>cmp",
              "<cmd>MarkdownPreviewToggle<cr>",
              desc = "Markdown preview",
            },
            sol.toggle({
              key = "<leader>cmr",
              name = "markdown rendering",
              get = function() return require("render-markdown.state").enabled end,
              set = function(enabled)
                if enabled then
                  require("render-markdown").enable()
                else
                  require("render-markdown").disable()
                end
              end,
            }),
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "markdownlint-cli2" },
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

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {
      enabled = false,
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
      checkbox = {
        enabled = false,
      },
    },
  },

  {
    "saghen/blink.cmp",
    --- @module "blink.cmp"
    --- @type blink.cmp.ConfigStrict
    opts = {
      sources = {
        default = { "markdown" },
        providers = {
          markdown = {
            name = "RenderMarkdown",
            module = "render-markdown.integ.blink",
            fallbacks = { "lsp" },
          },
        },
      },
    },
  },
}

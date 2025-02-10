---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
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
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown preview",
      },
    },
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
      on = {
        attach = function()
          Snacks.toggle({
            name = "markdown rendering",
            get = function() return require("render-markdown.state").enabled end,
            set = function(enabled)
              local m = require("render-markdown")
              if enabled then
                m.enable()
              else
                m.disable()
              end
            end,
          }):map("<leader>um")
        end,
      },
    },
  },
}

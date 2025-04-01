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
    "iamcco/markdown-preview.nvim",
    version = false,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown", "noice" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    init = function() vim.g.mkdp_filetypes = { "markdown", "noice" } end,
    config = function() vim.cmd("do FileType") end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "noice" },
    ---@module "render-markdown"
    ---@type render.md.Config
    opts = {
      enabled = true,

      completions = { lsp = { enabled = true } },

      file_types = { "markdown", "noice" },

      render_modes = true,

      code = {
        width = "block",
        sign = false,
        style = "language",
        language_name = true,
        border = "none",
      },

      heading = {
        position = "inline",
        backgrounds = {
          "Title",
          "Title",
          "Title",
          "Title",
          "Title",
          "Title",
        },
        foregrounds = {
          "Title",
          "Title",
          "Title",
          "Title",
          "Title",
          "Title",
        },
      },

      checkbox = {
        enabled = false,
      },
    },
  },
}

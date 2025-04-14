---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        html = {},
        vtsls = {
          keys = {
            {
              "<leader>co",
              function()
                local ft = vim.bo.filetype:gsub("react$", "")
                if not vim.tbl_contains({ "javascript", "typescript" }, ft) then
                  return
                end
                vim.lsp.buf_request(0, "workspace/executeCommand", {
                  command = (ft .. ".organizeImports"),
                  arguments = { vim.api.nvim_buf_get_name(0) },
                })
              end,
              desc = "Organize imports",
            },
          },

          settings = {
            vtsls = {
              autoUseWorkspaceTsdk = true,

              experimental = {
                maxInlayHintLength = 30,
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },

              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = true },
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
        css = { "prettierd" },
        html = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
      },
    },
  },
}

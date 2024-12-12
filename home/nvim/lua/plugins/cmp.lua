return {
  {
    "saghen/blink.cmp",
    init = function()
      vim.g.autocomplete_enabled = true
    end,
    opts = {
      enabled = function()
        return vim.g.autocomplete_enabled
      end,
      sources = {
        providers = {
          buffer = {
            enabled = false,
          },
          snippets = {
            enabled = false,
          },
          lsp = {
            transform_items = function(_, items)
              return vim.tbl_filter(function(item)
                local kind = vim.lsp.protocol.CompletionItemKind
                return item.kind ~= kind.Text and item.kind ~= kind.Snippet and item.kind ~= kind.Keyword
              end, items)
            end,
          },
        },
      },
    },
  },
}

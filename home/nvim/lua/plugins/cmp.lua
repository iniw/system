---@type LazySpec
return {
  {
    "saghen/blink.cmp",
    init = function()
      vim.g.autocomplete_enabled = true
    end,
    opts = {
      enabled = function()
        return vim.bo.buftype ~= "prompt" and vim.g.autocomplete_enabled
      end,
      keymap = {
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
      },
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

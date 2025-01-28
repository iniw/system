---@type LazySpec
return {
  {
    "saghen/blink.cmp",
    --- @type blink.cmp.ConfigStrict
    opts = {
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
                local kind = require("blink.cmp.types").CompletionItemKind
                return item.kind ~= kind.Text and item.kind ~= kind.Snippet and item.kind ~= kind.Keyword
              end, items)
            end,
          },
        },
      },
    },
  },
}

---@type LazySpec
return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    --- @module "blink.cmp"
    --- @type blink.cmp.ConfigStrict
    opts = {
      keymap = {
        preset = "enter",
        ["<c-j>"] = { "select_next", "fallback" },
        ["<c-k>"] = { "select_prev", "fallback" },
      },

      sources = {
        default = { "lsp" },
        cmdline = {},
      },

      completion = {
        keyword = {
          range = "full",
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 1000,
        },
      },
    },
    opts_extend = { "sources.default" },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      Snacks.toggle
        .new({
          name = "autocomplete (buffer)",
          get = function() return vim.b.completion ~= false end,
          set = function(state) vim.b.completion = state end,
        })
        :map("<leader>ua")
    end,
  },
}

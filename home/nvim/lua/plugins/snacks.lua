---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      words = {
        -- Remove the delay before updating
        debounce = 25,
      },

      dashboard = {
        sections = {
          [1] = { section = "keys", gap = 1 },
          -- Remove the header and footer
          [2] = nil,
          [3] = nil,
        },
      },

      terminal = {
        -- Remove terminal title bar
        win = {
          wo = {
            winbar = "",
          },
        },
      },
    },
    keys = {
      {
        "<leader><space>",
        function()
          Snacks.picker.smart({
            multi = { "buffers", "files" },
            cwd = vim.uv.cwd(),
            layout = {
              preview = false,
            },
          })
        end,
        desc = "Smart Find Files",
      },
      {
        "gad",
        function()
          Snacks.picker.lsp_definitions({
            confirm = "edit_vsplit",
          })
        end,
        desc = "Goto Definition in a New Window",
      },
    },
  },
}

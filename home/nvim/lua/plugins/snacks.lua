---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      -- Remove the delay before updating
      words = {
        debounce = 25,
      },

      -- Remove the header and footer
      dashboard = {
        sections = {
          [1] = { section = "keys", gap = 1 },
          [2] = nil,
          [3] = nil,
        },
      },

      -- Remove terminal title bar
      terminal = {
        win = {
          wo = {
            winbar = "",
          },
        },
      },

      -- Place explorer on the right side of the screen
      picker = {
        sources = {
          explorer = {
            layout = {
              layout = {
                position = "right",
              },
            },
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

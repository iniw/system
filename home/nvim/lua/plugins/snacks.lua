return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- Remove the delay before updating
      opts.words.debounce = 25

      -- Remove the header/footer
      opts.dashboard.sections = {
        { section = "keys", gap = 1, padding = 1 },
      }
    end,
    keys = {
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      {
        "gad",
        function()
          local snacks = require("snacks")
          snacks.picker.lsp_definitions({
            confirm = "edit_vsplit",
          })
        end,
        desc = "Goto Definition in a New Window",
      },
    },
  },
}

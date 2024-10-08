return {
  {
    "jake-stewart/multicursor.nvim",
    event = "VeryLazy",
    config = function()
      require("multicursor-nvim").setup()

      local function hl(group, definition)
        vim.api.nvim_set_hl(0, group, { link = definition })
      end

      hl("MultiCursorCursor", "TodoBgFIX")
      hl("MultiCursorSign", "TodoBgFIX")
      hl("MultiCursorVisual", "TodoBgWARN")
      hl("MultiCursorDisabledCursor", "@text.todo")
      hl("MultiCursorDisabledSign", "@text.todo")
      hl("MultiCursorDisabledVisual", "Substitute")
    end,
    keys = {
      -- add cursors above/below the main cursor, skipping empty lines
      {
        "<C-Up>",
        function()
          require("multicursor-nvim").lineAddCursor(-1)
        end,
        mode = { "n", "v" },
        desc = "Add cursor above",
      },
      {
        "<C-Down>",
        function()
          require("multicursor-nvim").lineAddCursor(1)
        end,
        mode = { "n", "v" },
        desc = "Add cursor below",
      },

      -- add a cursor and jump to the next/previous selection/word under cursor
      {
        "<C-n>",
        function()
          require("multicursor-nvim").matchAddCursor(1)
        end,
        mode = { "n", "v" },
        desc = "Add cursor + jump to next selection/word",
      },
      {
        "<C-p>",
        function()
          require("multicursor-nvim").matchAddCursor(-1)
        end,
        mode = { "n", "v" },
        desc = "Add cursor + jump to previous selection/word",
      },

      -- jump to the next/previous selection/word under cursor without adding a cursor
      {
        "<C-A-n>",
        function()
          require("multicursor-nvim").matchSkipCursor(1)
        end,
        mode = { "n", "v" },
        desc = "Next selection/word w/o adding a cursor",
      },
      {
        "<C-A-p>",
        function()
          require("multicursor-nvim").matchSkipCursor(-1)
        end,
        mode = { "n", "v" },
        desc = "Previous selection/word w/o adding a cursor",
      },

      {
        "<ESC>",
        function()
          local mc = require("multicursor-nvim")
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          elseif mc.hasCursors() then
            mc.clearCursors()
          end
          vim.cmd([[execute "normal! \<CMD>noh\<CR>\<ESC>"]])
        end,
        desc = "Escape, Clear hlsearch and remove muticursors.",
        mode = { "n", "v" },
      },
    },
  },
}

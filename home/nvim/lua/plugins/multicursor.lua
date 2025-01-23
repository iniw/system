---@type LazySpec
return {
  {
    "jake-stewart/multicursor.nvim",
    lazy = true,
    config = function()
      require("multicursor-nvim").setup()

      local function hl(group, definition)
        vim.api.nvim_set_hl(0, group, { link = definition })
      end

      hl("MultiCursorCursor", "TodoBgFIX")
      hl("MultiCursorSign", "TodoBgFIX")
    end,
    keys = {
      -- add cursors above/below the main cursor, skipping empty lines
      {
        "<C-Up>",
        function()
          require("multicursor-nvim").lineAddCursor(-1)
        end,
        mode = { "n", "v" },
        desc = "Add Cursor Above",
      },
      {
        "<C-Down>",
        function()
          require("multicursor-nvim").lineAddCursor(1)
        end,
        mode = { "n", "v" },
        desc = "Add Cursor Below",
      },

      -- add a cursor and jump to the next/previous selection/word under cursor
      {
        "<C-n>",
        function()
          require("multicursor-nvim").matchAddCursor(1)
        end,
        mode = { "n", "v" },
        desc = "Add Cursor + Jump to Next Selection/Word",
      },
      {
        "<C-p>",
        function()
          require("multicursor-nvim").matchAddCursor(-1)
        end,
        mode = { "n", "v" },
        desc = "Add Cursor + Jump to Previous Selection/Word",
      },

      -- jump to the next/previous selection/word under cursor without adding a cursor
      {
        "<C-A-n>",
        function()
          require("multicursor-nvim").matchSkipCursor(1)
        end,
        mode = { "n", "v" },
        desc = "Next Selection/Word Without Adding a Cursor",
      },
      {
        "<C-A-p>",
        function()
          require("multicursor-nvim").matchSkipCursor(-1)
        end,
        mode = { "n", "v" },
        desc = "Previous Selection/Word Without Adding a Cursor",
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
        desc = "Escape, Clear hlsearch and Remove Muticursors.",
        mode = { "n", "v" },
      },
    },
  },
}

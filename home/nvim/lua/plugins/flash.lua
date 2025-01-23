---@module "flash"

---@type LazySpec
return {
  {
    "folke/flash.nvim",
    vscode = true,
    ---@type Flash.Config
    opts = {
      search = {
        multi_window = false,
      },
      modes = {
        char = {
          -- mini.jump is used for this instead.
          enabled = false,
        },
      },
    },
    -- Override LazyVim's default keymaps.
    keys = function()
      return {
        {
          "<CR>",
          mode = { "n", "o", "v" },
          function()
            require("flash").jump()
          end,
        },
      }
    end,
  },
}

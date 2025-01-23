---@module "todo-comments"

---@type LazySpec
return {
  {
    "folke/todo-comments.nvim",
    ---@type TodoOptions
    opts = {
      highlight = {
        keyword = "wide_fg",
        -- Don't highlight the actual comment text, just the keyword.
        after = "",
      },
    },
  },
}

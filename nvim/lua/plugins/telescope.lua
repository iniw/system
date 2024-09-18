return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "gad",
        function()
          require("telescope.builtin").lsp_definitions({
            jump_type = "vsplit",
            attach_mappings = function(_, map)
              map({ "n", "i" }, "<CR>", require("telescope.actions").select_vertical)
              return true
            end,
          })
        end,
        desc = "Go to definition in a new window",
      },
    },
  },
}

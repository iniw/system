return {
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      {
        "gad",
        function()
          local fzf_lua = require("fzf-lua")
          fzf_lua.lsp_definitions({
            sync = true,
            ignore_current_line = true,
            jump_to_single_result = true,
            jump_to_single_result_action = fzf_lua.actions.file_vsplit,
            actions = {
              ["enter"] = fzf_lua.actions.file_vsplit,
            },
          })
        end,
        desc = "Goto Definition in a New Window",
      },
    },
  },
}

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "right",
      },
      filesystem = {
        -- Yazi is the netrw replacement
        hijack_netrw_behavior = "disabled",
      },
    },
  },
}

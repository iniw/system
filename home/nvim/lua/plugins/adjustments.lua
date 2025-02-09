---@type LazySpec
return {
  -- These have outdated semver releases
  { "tpope/vim-sleuth", version = false },
  { "lewis6991/gitsigns.nvim", version = false },
  { "mfussenegger/nvim-jdtls", version = false },
  { "nvim-lua/plenary.nvim", version = false },
  { "MunifTanjim/nui.nvim", version = false },

  -- These come by default with LazyVim but I don't want or care about them
  { "akinsho/bufferline.nvim", enabled = false },
  { "echasnovski/mini.pairs", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },
  { "williamboman/mason.nvim", enabled = false },
  { "windwp/nvim-ts-autotag", enabled = false },
}

return {
    "kylechui/nvim-surround",
    "chrisgrieser/nvim-various-textobjs",
    "wellle/targets.vim",
    "tpope/vim-repeat",
    "jessekelighine/vindent.vim",
    "projekt0n/github-nvim-theme",
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        keys = {
            { "<CR>", mode = { "n", "o" }, function()
                require("flash").jump({
                    jump = { autojump = true }
                })
                end
            }
        }
    }
}

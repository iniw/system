return {
    "kylechui/nvim-surround",
    "chrisgrieser/nvim-various-textobjs",
    "wellle/targets.vim",
    "tpope/vim-repeat",
    "jessekelighine/vindent.vim",
    "projekt0n/github-nvim-theme",
    {
        "folke/flash.nvim",
        keys = {
            { "<CR>", mode = { "n", "o" }, function()
                require("flash").jump({
                    jump = { autojump = true }
                })
                end
            }
        }
    },
    { 
        'vscode-neovim/vscode-multi-cursor.nvim',
        cond = not not vim.g.vscode,
        opts = {},
    }
}

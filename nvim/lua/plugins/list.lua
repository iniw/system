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
		opts = { modes = { char = { jump_labels = true } }
		},
		keys = {
			{ "s", mode = { "n", "x" }, function()
				require("flash").jump({
					search = { forward = true, wrap = false, multi_window = false },
					jump = { autojump = true }
				})
				end
			},
			{ "S", mode = { "n", "x" }, function()
				require("flash").jump({
					search = { forward = false, wrap = false, multi_window = false },
					jump = { autojump = true }
				})
				end
			},
			{ "z", mode = "o", function()
				require("flash").jump({
					search = { forward = true, wrap = false, multi_window = false },
					jump = { autojump = true }
				})
				end
			},
			{ "Z", mode = "o", function()
				require("flash").jump({
					search = { forward = false, wrap = false, multi_window = false },
					jump = { autojump = true }
				})
				end
			},
			{ "<CR>", mode = "n", function()
				require("flash").jump({
					continue = true
				})
				end
			}
		}
	}
}

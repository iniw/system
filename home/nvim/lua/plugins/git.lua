---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      lazygit = {
        enabled = true,
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = sol.OnFile,
    ---@module "gitsigns"
    ---@type Gitsigns.Config
    opts = {
      on_attach = function(buffer)
        local gs = require("gitsigns")
        require("which-key").add({
          buffer = buffer,
          { "<leader>gh", group = "hunks" },
          { "<leader>ghb", function() gs.blame_line({ full = true }) end, desc = "Blame line" },
          { "<leader>ghB", gs.blame, desc = "Blame buffer" },
          { "<leader>ghd", gs.diffthis, desc = "Diff this" },
          { "<leader>ghp", gs.preview_hunk_inline, desc = "Preview hunk inline" },
          {
            "<leader>ghr",
            function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
            desc = "Reset hunk",
            mode = { "n", "v" },
          },
          { "<leader>ghR", gs.reset_buffer, desc = "Reset buffer" },

          -- Movement
          {
            "]h",
            function()
              if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
              else
                gs.nav_hunk("next")
              end
            end,
            desc = "Next hunk",
          },
          {
            "[h",
            function()
              if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
              else
                gs.nav_hunk("prev")
              end
            end,
            desc = "Prev Hunk",
          },
          { "[H", function() gs.nav_hunk("first") end, desc = "First hunk" },
          { "]H", function() gs.nav_hunk("last") end, desc = "Last hunk" },

          -- Textobject
          { "ih", gs.select_hunk, desc = "Select hunk", mode = { "o", "x" } },
        })
      end,
    },
  },

  {
    -- FIXME: Move to the official one after these two PRs get merged:
    --        https://github.com/NeogitOrg/neogit/pull/1655
    --        https://github.com/NeogitOrg/neogit/pull/1654
    "iniw/neogit",
    dependencies = { "sindrets/diffview.nvim" },
    verson = false,
    cmd = "Neogit",
    ---@module "neogit"
    ---@type NeogitConfig
    opts = {
      auto_show_console_on = "error",

      disable_hint = true,

      graph_style = "unicode",

      integrations = {
        snacks = true,
      },
    },
  },
}

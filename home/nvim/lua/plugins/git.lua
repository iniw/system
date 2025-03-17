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

          -- Genreal
          { "<leader>gB", function() gs.blame_line({ full = true }) end, desc = "Blame line" },
          { "<leader>gb", gs.blame, desc = "Blame buffer" },

          -- Hunks
          { "<leader>gh", group = "hunks" },
          { "<leader>ghp", gs.preview_hunk_inline, desc = "Preview hunk inline" },
          {
            "<leader>ghr",
            gs.reset_hunk,
            desc = "Reset hunk",
            mode = "n",
          },
          {
            "<leader>ghr",
            function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
            desc = "Reset hunk",
            mode = "v",
          },
          {
            "<leader>ghs",
            gs.stage_hunk,
            desc = "Stage hunk",
            mode = "n",
          },
          {
            "<leader>ghs",
            function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
            desc = "Stage hunk",
            mode = "v",
          },

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

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    opts = {},
  },
}

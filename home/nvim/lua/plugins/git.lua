---@type LazySpec
return {
  {
    "folke/snacks.nvim",
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
    opts = {
      on_attach = function(buffer)
        local gs = require("gitsigns")
        require("which-key").add({
          {
            buffer = buffer,

            -- General
            { "<leader>g", group = "git" },
            { "<leader>gb", Snacks.picker.git_branches, desc = "Branches" },
            { "<leader>gd", Snacks.picker.git_diff, desc = "Diff (hunks)" },
            { "<leader>gf", Snacks.picker.git_log_file, desc = "Log file" },
            { "<leader>gg", Snacks.lazygit.open, desc = "Lazygit" },
            { "<leader>gl", Snacks.picker.git_log, desc = "Log" },
            { "<leader>gL", Snacks.picker.git_log_line, desc = "Log line" },
            { "<leader>gs", Snacks.picker.git_status, desc = "Status" },
            { "<leader>gS", Snacks.picker.git_stash, desc = "Stash" },

            -- Hunks
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
            {
              "<leader>ghs",
              function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
              desc = "Stage/Unstage hunk",
              mode = { "n", "v" },
            },
            { "<leader>ghS", gs.stage_buffer, desc = "Stage buffer" },

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
          },
        })
      end,
    },
  },
}

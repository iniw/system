return {
  {
    "mrcjkb/rustaceanvim",
    init = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              files = {
                excludeDirs = {
                  -- Exclude these directories otherwise ra gets utterly demolished attempting to analyze the entirety of nixpkgs.
                  ".direnv/",
                  ".git/",
                  ".github/",
                  ".gitlab",
                  "bin",
                  "node_modules",
                  "target",
                  "venv",
                },
              },
            },
          },
        },
      }
    end,
  },
}

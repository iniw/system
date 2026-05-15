{
  systemModule =
    { inputs, ... }:
    {
      nixpkgs.overlays = [ inputs.llm-agents.overlays.default ];

      nix.settings = {
        extra-substituters = [ "https://cache.numtide.com" ];
        extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
      };
    };

  homeManagerModule =
    { pkgs, ... }:
    {
      programs = {
        opencode = {
          enable = true;
          package = pkgs.llm-agents.opencode;

          context = ./AGENTS.md;
          skills = ./skills;

          settings = {
            lsp.rust = {
              command = [ "rust-analyzer" ];
              initialization = {
                cargo = {
                  features = "all";
                  targetDir = true;
                };
              };
            };

            permission.external_directory = {
              "~/work/**" = "allow";
            };
          };
        };

        git.ignores = [
          ".agents"
          ".claude"
          ".codex"
        ];
      };

      home.sessionVariables.OPENCODE_DISABLE_LSP_DOWNLOAD = "true";

      # amp
      home.packages = [ pkgs.llm-agents.amp ];
      xdg.configFile."amp/AGENTS.md".source = ./AGENTS.md;
    };
}

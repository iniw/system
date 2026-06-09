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
        codex = {
          enable = true;
          package = pkgs.llm-agents.codex;

          context = ./AGENTS.md;
          skills = ./skills;
        };

        git.ignores = [
          ".agents"
          ".claude"
          ".codex"
        ];
      };

      # amp
      home.packages = [ pkgs.llm-agents.amp ];
      xdg.configFile."amp/AGENTS.md".source = ./AGENTS.md;
      xdg.configFile."amp/skills".source = ./skills;
    };
}

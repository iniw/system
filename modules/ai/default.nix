{
  systemModule =
    { ... }:
    {
      nix.settings = {
        extra-substituters = [ "https://cache.numtide.com" ];
        extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
      };
    };

  homeManagerModule =
    { inputs, pkgs, ... }:
    let
      llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      programs = {
        codex = {
          enable = true;
          package = llm-agents.codex;

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
      home.packages = [ llm-agents.amp ];
      xdg.configFile."amp/AGENTS.md".source = ./AGENTS.md;
      xdg.configFile."amp/skills".source = ./skills;
    };
}

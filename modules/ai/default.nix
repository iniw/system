{
  homeManagerModule = { pkgs, inputs, ... }: {
    programs = {
      codex = {
        enable = true;

        context = ./AGENTS.md;
      };

      git.ignores = [
        ".agents"
        ".claude"
        ".codex"
      ];
    };

    # amp
    home.packages =
      let
        inherit (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}) amp;
      in
      [ amp ];

    xdg.configFile."amp/AGENTS.md".source = ./AGENTS.md;
  };
}

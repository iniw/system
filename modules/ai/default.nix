{
  homeManagerModule = { pkgs, ... }: {
    programs = {
      codex = {
        enable = true;

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
    home.packages =
      let
        amp = pkgs.writeShellApplication {
          name = "amp";

          runtimeInputs = with pkgs; [
            nodejs
            ripgrep
          ];

          text = ''
            exec npm exec --yes --quiet --package @ampcode/cli -- amp "$@"
          '';
        };
      in
      [ amp ];

    xdg.configFile = {
      "amp/AGENTS.md".source = ./AGENTS.md;
      "amp/skills".source = ./skills;
    };
  };
}

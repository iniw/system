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
    home.packages = [ pkgs.amp-cli ];
    xdg.configFile."amp/AGENTS.md".source = ./AGENTS.md;
    xdg.configFile."amp/skills".source = ./skills;
  };
}

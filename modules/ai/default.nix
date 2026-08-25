{
  homeManagerModule = {
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
  };
}

{
  homeModule =
    { pkgs-unstable, ... }:
    {
      home.packages = with pkgs-unstable; [
        claude-code
        amp-cli
      ];

      programs.git.ignores = [
        ".claude"
        "CLAUDE.md"
        "AGENTS.md"
      ];
    };
}

{
  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
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

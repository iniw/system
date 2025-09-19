{
  homeModule =
    { pkgs-unstable, ... }:
    {
      home.packages = with pkgs-unstable; [
        claude-code
        gemini-cli
      ];
      programs.git.ignores = [ ".claude" ];
    };
}

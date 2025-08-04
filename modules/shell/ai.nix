{
  homeModule =
    { pkgs-unstable, ... }:
    {
      home.packages = [ pkgs-unstable.claude-code ];
      programs.git.ignores = [ ".claude" ];
    };
}

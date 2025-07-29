{
  nixosHomeModule =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.cmusfm ];
      programs.cmus.enable = true;
    };
}

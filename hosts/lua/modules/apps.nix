{
  homeModule =
    { pkgs, ... }:
    {
      # cmus
      home.packages = [ pkgs.cmusfm ];
      programs.cmus.enable = true;

      # OBS
      programs.obs-studio.enable = true;
    };
}

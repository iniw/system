{
  darwinSystemModule = {
    homebrew.casks = [ "ticktick" ];
  };

  homeModule =
    {
      pkgs,
      pkgs-unstable,
      ...
    }:
    {
      home.packages = [
        pkgs.discord
        pkgs.google-chrome
        # FIXME: Go back to stable once the app actually works on macos.
        pkgs-unstable.spotify
      ];
    };

  nixosHomeModule =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.cmusfm
        pkgs.ticktick
      ];

      programs = {
        cmus.enable = true;

        obs-studio.enable = true;
      };
    };
}

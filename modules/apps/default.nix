{
  homeModule =
    { pkgs, pkgs-unstable, ... }:
    {
      home.packages = [
        pkgs.discord
        pkgs.google-chrome
        # FIXME: Go back to stable once the app actually works on macos.
        pkgs-unstable.spotify
      ];
    };

  nixosHomeModule = {
    programs.obs-studio.enable = true;
  };
}

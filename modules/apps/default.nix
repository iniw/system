{
  darwinModule = {
    homebrew.casks = [ "ticktick" ];
  };

  homeModule =
    {
      lib,
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
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        pkgs.cmusfm
        pkgs.ticktick
      ];

      programs = lib.optionalAttrs pkgs.stdenv.isLinux {
        cmus.enable = true;

        obs-studio.enable = true;
      };
    };
}

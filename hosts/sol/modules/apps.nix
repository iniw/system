{
  systemModule = {
    homebrew.casks = [
      "netnewswire"
      "stremio"
      "zoom"

      "mos" # Fixes mouse scroll on Safari
      "reflex-app" # Fixes media keys on Safari
    ];
  };

  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        google-chrome
      ];
    };
}

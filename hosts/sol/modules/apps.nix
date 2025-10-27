{
  systemModule = {
    homebrew.casks = [
      "stremio"
      "qobuz"
      "zoom"
      "android-studio"
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

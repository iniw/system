{
  systemModule = {
    homebrew.casks = [
      "stremio"
      "qobuz"
      "zoom"
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

{
  systemModule = {
    homebrew.casks = [
      "notion"
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

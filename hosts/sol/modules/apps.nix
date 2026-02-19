{
  systemModule = {
    homebrew.casks = [
      "stremio"
      "reflex-app" # Fixes media keys on Safari
    ];
  };

  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        google-chrome
        mos
        net-news-wire
        zoom-us
      ];
    };
}

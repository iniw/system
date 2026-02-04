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
        mos
        net-news-wire
        zoom-us
      ];
    };
}

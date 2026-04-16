{
  systemModule = {
    homebrew.casks = [
      "reflex-app" # Fixes media keys on Safari
    ];
  };

  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        caffeine
        google-chrome
        mos
        net-news-wire
        zoom-us
      ];
    };
}

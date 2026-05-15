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
        discord
        google-chrome
        mos
        net-news-wire
        xld
      ];
    };
}

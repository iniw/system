{
  systemModule = {
    programs.mas = {
      enable = true;

      packages = {
        FastScrobbler = 6759501541;
        wBlock = 6746388723;
        WhatsApp = 310633997;
        Xcode = 497799835;
      };
    };
  };

  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        caffeine
        google-chrome
        mos
        net-news-wire
        reflex-app
      ];
    };
}

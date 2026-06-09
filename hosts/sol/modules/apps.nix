{
  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        caffeine
        google-chrome
        mos
        net-news-wire
        reflex-app
        xld
      ];
    };
}

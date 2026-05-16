{
  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        caffeine
        discord
        google-chrome
        mos
        net-news-wire
        reflex-app
        xld
      ];
    };
}

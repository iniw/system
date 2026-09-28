{
  homeManagerModule = { pkgs, inputs, ... }: {
    home.packages =
      with pkgs;
      let
        inherit (inputs.self.packages.${stdenv.hostPlatform.system}) seeleseek space-rabbit;
      in
      [
        caffeine
        google-chrome
        mos
        net-news-wire
        reflex-app
        seeleseek
        space-rabbit
        spotify
      ];
  };

  systemModule = {
    programs.mas = {
      enable = true;

      packages = {
        "1Password for Safari" = 1569813296;
        FastScrobbler = 6759501541;
        WhatsApp = 310633997;
        Xcode = 497799835;
        wBlock = 6746388723;
      };

      update = false;
    };
  };
}

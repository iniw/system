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
        WhatsApp = 310633997;
        Xcode = 497799835;
        wBlock = 6746388723;
      };

      update = false;
    };
  };
}

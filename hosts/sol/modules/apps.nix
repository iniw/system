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
      ];
  };

  systemModule =
    {
      config,
      user,
      lib,
      ...
    }:
    {
      programs.mas = {
        enable = true;

        packages = {
          FastScrobbler = 6759501541;
          wBlock = 6746388723;
          WhatsApp = 310633997;
          Xcode = 497799835;
        };

        update = false;
      };

      system.defaults.dock.persistent-apps =
        let
          inherit (config.users.users.${user}) home;
        in
        lib.mkAfter [
          { app = "${home}/Applications/Home Manager Apps/NetNewsWire.app"; }
          { app = "${home}/Applications/Home Manager Apps/seeleseek.app"; }
        ];
    };
}

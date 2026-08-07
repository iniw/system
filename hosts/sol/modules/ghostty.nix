{
  homeManagerModule = {
    programs.ghostty.settings.font-size = 15;
  };

  systemModule =
    {
      config,
      user,
      lib,
      ...
    }:
    {
      system.defaults.dock.persistent-apps =
        let
          inherit (config.users.users.${user}) home;
        in
        lib.mkBefore [
          { app = "${home}/Applications/Home Manager Apps/Ghostty.app"; }
        ];
    };
}

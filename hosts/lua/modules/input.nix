{
  systemModule = {
    i18n = {
      defaultLocale = "en_US.UTF-8";
      inputMethod = {
        enable = true;
        type = "ibus";
      };
    };
  };

  homeManagerModule =
    { lib, ... }:
    {
      dconf.settings = {
        "org/gnome/desktop/input-sources" = {
          xkb-options = [ "caps:escape" ];
          sources = [
            (lib.hm.gvariant.mkTuple [
              "xkb"
              "br"
            ])
          ];
        };

        "org/gnome/desktop/peripherals/keyboard" = {
          delay = lib.hm.gvariant.mkUint32 200;
          repeat = lib.hm.gvariant.mkUint32 20;
        };

        "org/gnome/desktop/peripherals/mouse" = {
          speed = -0.20;
        };
      };
    };
}

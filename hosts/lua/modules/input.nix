{
  homeModule =
    { lib, ... }:
    {
      dconf.settings = {
        "org/gnome/desktop/input-sources".sources = [
          (lib.hm.gvariant.mkTuple [
            "xkb"
            "br"
          ])
        ];

        "org/gnome/desktop/peripherals/mouse".speed = -0.20;
      };
    };

  systemModule = {
    i18n = {
      defaultLocale = "en_US.UTF-8";
      inputMethod = {
        enable = true;
        type = "ibus";
      };
    };
  };
}

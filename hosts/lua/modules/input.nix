{
  systemModule = {
    nixpkgs.overlays = [
      (final: prev: {
        mutter = prev.mutter.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [
            # Remove after upgrading to GNOME 51.
            (final.fetchpatch {
              url = "https://github.com/GNOME/mutter/commit/3fe9b5fb2b3f14698e1880336ea57af023ec09cf.patch";
              hash = "sha256-O9oW6Y2Ey4S9R368HVOFHViLKi5r6bzyDlyaMamcF58=";
            })
          ];
        });
      })
    ];

    time.timeZone = "America/Sao_Paulo";

    i18n = {
      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
        LC_ADDRESS = "pt_BR.UTF-8";
        LC_IDENTIFICATION = "pt_BR.UTF-8";
        LC_MEASUREMENT = "pt_BR.UTF-8";
        LC_MONETARY = "pt_BR.UTF-8";
        LC_NAME = "pt_BR.UTF-8";
        LC_NUMERIC = "pt_BR.UTF-8";
        LC_PAPER = "pt_BR.UTF-8";
        LC_TELEPHONE = "pt_BR.UTF-8";
        LC_TIME = "pt_BR.UTF-8";
      };

      inputMethod = {
        enable = true;
        type = "ibus";
      };
    };

    console.keyMap = "br-abnt2";
  };

  homeManagerModule = { lib, ... }: {
    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = [
          "caps:escape"
          "compose:ralt"
        ];
        sources = [
          (lib.hm.gvariant.mkTuple [
            "xkb"
            "br+nodeadkeys"
          ])
        ];
      };

      "org/gnome/desktop/peripherals/keyboard" = {
        delay = lib.hm.gvariant.mkUint32 180;
        repeat-interval = lib.hm.gvariant.mkUint32 33;
      };

      "org/gnome/desktop/peripherals/mouse" = {
        speed = -0.20;
      };
    };
  };
}

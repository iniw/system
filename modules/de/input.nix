{
  darwinSystemModule = {
    system = {
      defaults = {
        NSGlobalDomain = {
          InitialKeyRepeat = 12;
          KeyRepeat = 2;
        };

        trackpad = {
          Clicking = true;
          TrackpadThreeFingerDrag = true;
        };
      };

      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };
    };
  };

  nixosHomeModule =
    { lib, ... }:
    {
      dconf.settings = {
        "org/gnome/desktop/input-sources" = {
          xkb-options = [ "caps:escape" ];
        };

        "org/gnome/desktop/peripherals/keyboard" = {
          delay = lib.hm.gvariant.mkUint32 200;
          repeat = lib.hm.gvariant.mkUint32 20;
        };
      };
    };
}

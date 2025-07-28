{
  nixosModule = {
    services.xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  homeModule =
    { lib, pkgs, ... }:
    lib.mkIf pkgs.stdenv.isLinux {
      dconf = {
        enable = true;

        settings = {
          "org/gnome/desktop/input-sources" = {
            sources = [
              (lib.hm.gvariant.mkTuple [
                "xkb"
                "br"
              ])
            ];

            xkb-options = [
              "caps:escape"
            ];
          };

          "org/gnome/desktop/peripherals/keyboard" = {
            delay = lib.hm.gvariant.mkUint32 200;
            repeat = lib.hm.gvariant.mkUint32 20;
          };

          "org/gnome/desktop/peripherals/mouse" = {
            speed = -0.20;
          };

          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            font-hinting = "full";
            font-antialiasing = "rgba";
          };

          "org/gnome/desktop/session" = {
            idle-delay = lib.hm.gvariant.mkUint32 0;
          };

          "org/gnome/shell" = {
            favorite-apps = [
              "google-chrome.desktop"
              "com.mitchellh.ghostty.desktop"
              "discord.desktop"
              "spotify.desktop"
            ];
          };
        };
      };
    };
}

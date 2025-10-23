{
  systemModule = {
    services.xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  homeManagerModule =
    { lib, ... }:
    {
      dconf = {
        enable = true;

        settings = {
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
              "com.mitchellh.ghostty.desktop"
              "google-chrome.desktop"
              "discord.desktop"
            ];
          };
        };
      };
    };
}

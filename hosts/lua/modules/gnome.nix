{
  systemModule = {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome = {
        games.enable = false;
        core-developer-tools.enable = false;
      };
    };
  };

  homeManagerModule = {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "com.mitchellh.ghostty.desktop"
          "1password.desktop"
          "firefox.desktop"
          "discord.desktop"
          "thunderbird.desktop"
          "steam.desktop"
        ];
      };
    };
  };
}

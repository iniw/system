{
  systemModule = { pkgs, ... }: {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome = {
        games.enable = false;
        core-developer-tools.enable = false;
      };
    };

    environment.systemPackages = with pkgs; [
      gnomeExtensions.astra-monitor
    ];
  };

  homeManagerModule = {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      "org/gnome/shell" = {
        always-show-log-out = true;
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

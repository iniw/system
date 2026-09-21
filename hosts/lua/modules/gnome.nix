{
  systemModule = { pkgs, ... }: {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    environment.systemPackages = with pkgs; [
      gnomeExtensions.astra-monitor
    ];
  };

  homeManagerModule = {
    xdg.autostart.enable = true;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      "org/gnome/shell" = {
        always-show-log-out = true;
        favorite-apps = [ "org.gnome.Nautilus.desktop" ];
      };
    };
  };
}

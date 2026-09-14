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
}

{
  homeModule =
    { pkgs-unstable, ... }:
    {
      programs.ghostty = {
        enable = true;
        package =
          if pkgs-unstable.stdenv.isDarwin then pkgs-unstable.ghostty-bin else pkgs-unstable.ghostty;
      };

      xdg.configFile.ghostty = {
        source = ./config;
        recursive = true;
      };
    };

  nixosHomeModule = {
    # Remove some default keybinds that conflict with the config.
    dconf = {
      "org/gnome/shell/keybindings" = {
        # super+s
        toggle-quick-settings = [ ];
        # super+v
        toggle-message-tray = [ ];
        # super+n
        focus-active-notification = [ ];
        # super+alt+up
        shift-overview-up = [ ];
        # super+alt+down
        shift-overview-down = [ ];
      };

      "org/gnome/desktop/wm/keybindings" = {
        # super+h
        minimize = [ ];
        # super+up
        maximize = [ ];
        # super+down
        unmaximize = [ ];
        # super+shift+up
        move-to-monitor-up = [ ];
        # super+shift+down
        move-to-monitor-down = [ ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        # super+l
        screensaver = [ ];
      };
    };
  };
}

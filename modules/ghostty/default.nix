{
  homeModule =
    { pkgs, pkgs-unstable, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.isDarwin then pkgs-unstable.ghostty-bin else pkgs-unstable.ghostty;
      };

      xdg.configFile."ghostty" = {
        source = ./config;
        recursive = true;
      };
    };

  nixosHomeModule = {
    # Remove some default keybinds that conflict with the config.
    dconf = {
      "org/gnome/shell/keybindings" = {
        # <Super>s
        toggle-quick-settings = [ ];
        # <Super>v
        toggle-message-tray = [ ];
        # <Super>n
        focus-active-notification = [ ];
        # <Super><Alt>Up
        shift-overview-up = [ ];
        # <Super><Alt>Down
        shift-overview-down = [ ];
      };

      "org/gnome/desktop/wm/keybindings" = {
        # <Super>h
        minimize = [ ];
        # <Super>Up
        maximize = [ ];
        # <Super>Down
        unmaximize = [ ];
        # <Super><Shift>Up
        move-to-monitor-up = [ ];
        # <Super><Shift>Down
        move-to-monitor-down = [ ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        # <Super>l
        screensaver = [ ];
      };

      "org/gnome/mutter/keybindings" = {
        # <Super>p
        switch-monitor = [ ];
      };
    };
  };
}

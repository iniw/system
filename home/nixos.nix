{
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./shared.nix ];

  home = {
    packages = with pkgs; [
      xclip
      firefox
      gcc14
    ];
  };

  programs = {
    wezterm = {
      enable = true;
    };
  };

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

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      # Remove conflicting shortcuts
      "org/gnome/shell/keybindings" = {
        # <Super>s
        toggle-quick-settings = [ ];
        # <Super>v
        toggle-message-tray = [ ];
        # <Super>[0..=9]
        switch-to-application-1 = [ ];
        switch-to-application-2 = [ ];
        switch-to-application-3 = [ ];
        switch-to-application-4 = [ ];
        switch-to-application-5 = [ ];
        switch-to-application-6 = [ ];
        switch-to-application-7 = [ ];
        switch-to-application-8 = [ ];
        switch-to-application-9 = [ ];
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

{
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./shared.nix ];

  home = {
    packages = with pkgs; [
      spotify
      cmusfm

      # For the neovim system clipboard
      xclip
      # For treesitter
      gcc14
    ];
  };

  xdg = {
    configFile = {
      "ghostty" = {
        source = ./ghostty;
        recursive = true;
      };
    };
  };

  programs = {
    cmus = {
      enable = true;
    };

    firefox = {
      enable = true;
    };

    ghostty = {
      enable = true;
      package = pkgs.ghostty;
    };

    obs-studio = {
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

      "org/gnome/desktop/peripherals/keyboard" = {
        delay = lib.hm.gvariant.mkUint32 200;
        repeat = lib.hm.gvariant.mkUint32 20;
      };

      "org/gnome/desktop/peripherals/mouse" = {
        speed = -0.20;
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";

        font-name = "Inter Variable 11";
        document-font-name = "Inter Variable 11";
        monospace-font-name = "Berkeley Mono 10";

        font-hinting = "full";
        font-antialiasing = "rgba";
      };

      "org/gnome/desktop/session" = {
        idle-delay = lib.hm.gvariant.mkUint32 0;
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "firefox.desktop"
          "com.mitchellh.ghostty.desktop"
          "discord.desktop"
          "spotify.desktop"
        ];
      };

      # Remove conflicting shortcuts with the terminal emulator
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

{
  systemModule = { pkgs, ... }: {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.plasma-login-manager.enable = true;
    };

    # Makes the breeze cursor available to steam.
    # See: https://github.com/NixOS/nixpkgs/issues/437281
    programs.steam.extraPackages = [ pkgs.kdePackages.breeze ];

    # Since GTK 4.20, GTK apps on Wayland expect the compositor to handle compose keys. KWin only does that when an
    # input method (e.g. fcitx5) is running. This makes GTK handle them itself again.
    environment.sessionVariables.GTK_IM_MODULE = "simple";
  };

  homeManagerModule = { inputs, pkgs, ... }: {
    imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

    home.packages = with pkgs; [
      kdePackages.kcalc
      kdePackages.kolourpaint
      wl-clipboard
    ];

    xdg.autostart.enable = true;

    programs.plasma = {
      enable = true;

      workspace.lookAndFeel = "org.kde.breezedark.desktop";

      panels = [
        {
          location = "top";
          height = 27;
          floating = true;
          widgets = [
            "org.kde.plasma.kickoff"
            "org.kde.plasma.appmenu"
            "org.kde.plasma.panelspacer"
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
          ];
        }
        {
          location = "bottom";
          height = 50;
          floating = true;
          hiding = "autohide";
          lengthMode = "fit";
          widgets = [
            {
              iconTasks.launchers = [
                "preferred://filemanager"
                "applications:com.mitchellh.ghostty.desktop"
                "applications:firefox.desktop"
                "applications:discord.desktop"
                "applications:thunderbird.desktop"
                "applications:spotify.desktop"
                "applications:slack.desktop"
              ];
            }
          ];
        }
      ];

      input.keyboard = {
        layouts = [
          {
            layout = "br";
            variant = "nodeadkeys";
          }
        ];

        options = [
          "caps:escape"
          "compose:ralt"
        ];

        repeatDelay = 250;
        repeatRate = 30;
      };

      kwin.effects.shakeCursor.enable = false;

      shortcuts.kwin = {
        "Window Move Center" = "Meta+Shift+C";
        "Walk Through Windows of Current Application" = [
          "Alt+'"
          "Meta+'"
        ];
        "Walk Through Windows of Current Application (Reverse)" = [
          ''Alt+"''
          ''Meta+"''
        ];
      };

      configFile = {
        plasmanotifyrc.Notifications.PopupPosition = "TopRight";

        spectaclerc = {
          General.clipboardGroup = "PostScreenshotCopyImage";
          GuiConfig = {
            includePointer = true;
            quitAfterSaveCopyExport = true;
          };
        };
      };
    };
  };
}

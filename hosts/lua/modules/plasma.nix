{
  systemModule = { pkgs, ... }: {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.plasma-login-manager.enable = true;
    };

    # Makes the breeze cursor available to steam.
    # See: https://github.com/NixOS/nixpkgs/issues/437281
    programs.steam.extraPackages = [ pkgs.kdePackages.breeze ];

    environment.sessionVariables = {
      # Since GTK 4.20, GTK apps on Wayland expect the compositor to handle compose keys. KWin only does that when an
      # input method is running, but IMEs are annoying to configure declaratively on plasma so I don't run one. This makes
      # GTK handle them itself again.
      GTK_IM_MODULE = "simple";

      # See https://wiki.nixos.org/wiki/Wayland#Electron_and_Chromium
      NIXOS_OZONE_WL = 1;
    };
  };

  homeManagerModule = { inputs, pkgs, ... }: {
    imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

    home.packages = with pkgs.kdePackages; [
      kcalc
      kolourpaint
    ];

    xdg = {
      autostart.enable = true;
      mimeApps.enable = true;
    };

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
                "preferred://terminal"
                "preferred://browser"
                "preferred://mailer"
                "applications:spotify.desktop"
                "applications:discord.desktop"
                "applications:slack.desktop"
              ];
            }
          ];
        }
      ];

      input = {
        keyboard = {
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

        mice = [
          {
            name = "Logitech G403 HERO Gaming Mouse";
            vendorId = "046d";
            productId = "c08f";
            naturalScroll = true;
            acceleration = -0.2;
            accelerationProfile = "none";
          }
        ];
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
        # Alt+Tab settings
        kwinrc.TabBox = {
          # Show one entry per app instead of one per window.
          ApplicationsMode = 1;
          # Put minimized windows last.
          OrderMinimizedMode = 1;
        };

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

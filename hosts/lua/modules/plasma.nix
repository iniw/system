{
  systemModule = { pkgs, ... }: {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.plasma-login-manager.enable = true;
    };

    # Makes the breeze cursor available to steam.
    # See: https://github.com/NixOS/nixpkgs/issues/437281
    programs.steam.extraPackages = [ pkgs.kdePackages.breeze ];

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
    };

    # See https://wiki.nixos.org/wiki/Wayland#Electron_and_Chromium
    environment.sessionVariables.NIXOS_OZONE_WL = 1;
  };

  homeManagerModule =
    {
      inputs,
      osConfig,
      pkgs,
      ...
    }:
    {
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

        workspace = {
          lookAndFeel = "org.kde.breezedark.desktop";
        };

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
            options = [
              "caps:escape"
              "compose:ralt"
            ];

            repeatDelay = 180;
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

        kwin = {
          effects.shakeCursor.enable = false;
        };

        shortcuts = {
          kwin = {
            "Window Move Center" = "Meta+Shift+C";
          };
        };

        configFile = {
          kwinrc = {
            # Alt+Tab settings
            TabBox = {
              # Show one entry per app instead of one per window.
              ApplicationsMode = 1;
              # Put minimized windows last.
              OrderMinimizedMode = 1;
            };

            # Makes KWin start fcitx5 as the input method ("Virtual Keyboard" in System Settings).
            Wayland.InputMethod = "${osConfig.i18n.inputMethod.package}/share/applications/org.fcitx.Fcitx5.desktop";
          };

          plasmanotifyrc = {
            Notifications.PopupPosition = "TopRight";
          };

          spectaclerc = {
            General.clipboardGroup = "PostScreenshotCopyImage";
            GuiConfig.quitAfterSaveCopyExport = true;
          };
        };
      };
    };
}

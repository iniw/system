{
  user,
  inputs,
  ...
}:
{
  imports = [ ./shared.nix ];

  users = {
    users.${user} = {
      home = "/Users/${user}";
      uid = 501;
    };

    knownUsers = [ user ];
  };

  home-manager = {
    users.${user}.imports = [
      ./../home/darwin.nix
      inputs.mac-app-util.homeManagerModules.default
    ];
  };

  nix = {
    # Managed by determinate nix
    enable = false;
  };

  nixpkgs = {
    hostPlatform = "x86_64-darwin";
  };

  security = {
    pam = {
      services = {
        sudo_local = {
          touchIdAuth = true;
        };
      };
    };
  };

  system = {
    primaryUser = user;

    defaults = {
      NSGlobalDomain = {
        _HIHideMenuBar = true;

        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        AppleShowAllFiles = true;

        InitialKeyRepeat = 12;
        KeyRepeat = 2;

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;

        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };

      dock = {
        autohide = true;
        mru-spaces = false;
        show-recents = false;
        orientation = "bottom";
        showhidden = true;
        tilesize = 32;
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;

        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";

        QuitMenuItem = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    stateVersion = 5;
  };

  # Homebrew
  nix-homebrew = {
    enable = true;

    inherit user;

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };

    mutableTaps = false;
  };

  homebrew = {
    enable = true;

    brews = [
      {
        name = "mysql";
        restart_service = "changed";
        conflicts_with = [ "mysql" ];
      }
    ];

    casks = [
      "ticktick"
      "notion"
    ];

  };
}

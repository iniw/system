{ pkgs, user, ... }:
{
  services.nix-daemon.enable = true;

  nixpkgs = {
    hostPlatform = "x86_64-darwin";
    config.allowUnfree = true;
  };

  nix.package = pkgs.nix;

  programs.zsh.enable = true;
  users.users.${user}.shell = pkgs.zsh;

  system = {
    activationScripts.postUserActivation.text = ''
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      NSGlobalDomain = {
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

    stateVersion = 4;
  };
}

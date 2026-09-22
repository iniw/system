{
  systemModule = { pkgs, ... }: {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.plasma-login-manager.enable = true;
    };
    # Makes the breeze cursor available to steam.
    # See: https://github.com/NixOS/nixpkgs/issues/437281
    programs.steam.extraPackages = [ pkgs.kdePackages.breeze ];
  };

  homeManagerModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      haruna
      kdePackages.kcalc
      kdePackages.kolourpaint
      wl-clipboard
    ];

    xdg.autostart.enable = true;
  };
}

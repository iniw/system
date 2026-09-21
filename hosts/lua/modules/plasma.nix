{
  systemModule = {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.plasma-login-manager.enable = true;
    };
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

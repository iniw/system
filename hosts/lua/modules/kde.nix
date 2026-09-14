{
  systemModule = { pkgs, ... }: {
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      discover
      elisa
      kate
      konsole
    ];

    services = {
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
    };
  };

  homeManagerModule = { pkgs, ... }: {
    home.packages = with pkgs.kdePackages; [
      kcontacts
      kolourpaint
      kmail
      kmail-account-wizard
      kcalc
    ];
  };
}

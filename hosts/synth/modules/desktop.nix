{
  systemModule = {
    services = {
      xserver = {
        enable = true;
        xkb = {
          layout = "us";
          variant = "intl";
        };
      };

      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
    };
  };

  homeManagerModule = {
    programs.firefox.enable = true;
  };
}

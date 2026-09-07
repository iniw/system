sys:
sys.nixos (
  { user, pkgs, ... }:
  {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;

    home-manager.users.${user} = {
      dconf.enable = false;
      home.stateVersion = "26.11";
    };

    system.stateVersion = "26.11";
  }
)

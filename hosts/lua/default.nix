sys:
sys.nixos (
  { user, pkgs, ... }:
  {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      kernelPackages = pkgs.linuxPackages_latest;
    };

    home-manager.users.${user}.home.stateVersion = "26.11";
    system.stateVersion = "26.11";
  }
)

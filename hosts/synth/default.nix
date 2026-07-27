sys:
sys.nixosSystem (
  { pkgs, user, ... }:
  {
    system.etc.overlay.enable = true;

    boot = {
      initrd.systemd.enable = true;
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
    };

    home-manager.users.${user}.home.stateVersion = "26.11";
    system.stateVersion = "26.05";
  }
)

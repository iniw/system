{
  systemModule =
    { pkgs, ... }:
    {
      system.etc.overlay.enable = true;

      boot = {
        initrd.systemd.enable = true;

        kernelPackages = pkgs.linuxPackages_latest;

        loader = {
          systemd-boot = {
            enable = true;

            configurationLimit = 5;
          };

          grub.enable = false;

          efi.canTouchEfiVariables = true;
        };
      };
    };
}

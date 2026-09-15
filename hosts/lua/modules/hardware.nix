{
  systemModule =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot = {
        initrd.availableKernelModules = [
          "ahci"
          "nvme"
          "sd_mod"
          "thunderbolt"
          "usb_storage"
          "usbhid"
          "xhci_pci"
          "xhci_pci_prom21"
        ];
        kernelModules = [ "kvm-amd" ];
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/6415ab9d-dfa9-4300-8e4c-c96db5eba1db";
          fsType = "ext4";
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/0CE4-FEEF";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}

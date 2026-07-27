{
  systemModule = {
    boot = {
      initrd.availableKernelModules = [
        "ehci_pci"
        "ahci"
        "xhci_pci"
        "nvme"
        "usbhid"
        "sr_mod"
      ];
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/24acf555-d686-4c4e-8894-2ada73a08154";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/101E-23BC";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
    };

    nixpkgs.hostPlatform = "aarch64-linux";
  };
}

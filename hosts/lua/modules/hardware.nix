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

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}

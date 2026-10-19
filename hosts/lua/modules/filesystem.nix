{
  systemModule = {
    fileSystems =
      let
        subvolume = options: {
          device = "/dev/disk/by-uuid/6415ab9d-dfa9-4300-8e4c-c96db5eba1db";
          fsType = "btrfs";
          inherit options;
        };
      in
      {
        "/" = subvolume [
          "subvol=@"
          "compress=zstd:1"
        ];
        "/home" = subvolume [
          "subvol=@home"
          "compress=zstd:1"
        ];
        "/nix" = subvolume [
          "subvol=@nix"
          "compress=zstd:1"
          "noatime"
        ];
        "/swap" = subvolume [
          "subvol=@swap"
          "noatime"
        ];
        "/boot" = {
          device = "/dev/disk/by-uuid/0CE4-FEEF";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };
      };

    swapDevices = [
      {
        device = "/swap/swapfile";
        size = 16 * 1024;
      }
    ];

    services.btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
    };
  };
}

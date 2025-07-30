{ name, sys }:
sys.nixosSystem {
  inherit name;
  system = "x86_64-linux";
  module =
    { user, ... }:
    {
      imports = [
        ./hardware.nix
        ./input.nix
        ./video.nix
      ];

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      time.timeZone = "America/Sao_Paulo";

      users.users.${user}.extraGroups = [ "networkmanager" ];
      networking.networkmanager.enable = true;

      home-manager.users.${user}.home.stateVersion = "25.05";
      system.stateVersion = "25.05";
    };
}

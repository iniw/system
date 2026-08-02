sys:
sys.nixos (
  { user, ... }:
  {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    time.timeZone = "America/Sao_Paulo";

    users.users.${user}.extraGroups = [ "networkmanager" ];
    networking.networkmanager.enable = true;

    home-manager.users.${user}.home.stateVersion = "26.11";
    system.stateVersion = "26.11";
  }
)

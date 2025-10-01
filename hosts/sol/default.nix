sys:
sys.darwinSystem (
  { user, ... }:
  {
    imports = [
      ./hardware.nix
    ];

    # Managed by determinate nix.
    nix.enable = false;

    home-manager.users.${user}.home.stateVersion = "25.05";
    system.stateVersion = 5;
  }
)

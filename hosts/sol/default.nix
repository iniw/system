sys:
sys.darwinSystem (
  { user, ... }:
  {
    # Managed by determinate nix.
    nix.enable = false;

    home-manager.users.${user}.home.stateVersion = "25.05";
    system.stateVersion = 5;
  }
)

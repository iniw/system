sys:
sys.nixosSystem (
  { user, ... }:
  {
    home-manager.users.${user}.home.stateVersion = "26.11";
    system.stateVersion = "26.05";
  }
)

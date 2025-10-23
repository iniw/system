sys:
sys.darwinSystem (
  { user, ... }:
  {
    home-manager.users.${user}.home.stateVersion = "25.05";
    system.stateVersion = 5;
  }
)

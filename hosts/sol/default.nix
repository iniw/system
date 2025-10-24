sys:
sys.darwinSystem (
  { user, ... }:
  {
    home-manager.users.${user}.home.stateVersion = "25.11";
    system.stateVersion = 5;
  }
)

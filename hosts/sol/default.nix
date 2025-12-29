sys:
sys.darwinSystem (
  { user, ... }:
  {
    home-manager.users.${user}.home.stateVersion = "26.05";
    system.stateVersion = 5;
  }
)

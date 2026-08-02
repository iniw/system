sys:
sys.darwin (
  { user, ... }:
  {
    home-manager.users.${user}.home.stateVersion = "26.11";
    system.stateVersion = 5;
  }
)

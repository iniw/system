sys:
sys.nixos (
  { user, ... }: {
    home-manager.users.${user}.home.stateVersion = "26.11";
    system.stateVersion = "26.11";
  }
)

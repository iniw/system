{
  systemModule = { user, ... }: {
    security = {
      run0.enable = true;
      sudo.enable = false;
    };

    users.users.${user}.extraGroups = [ "wheel" ];
  };
}

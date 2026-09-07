{
  systemModule = { user, ... }: {
    services.openssh.enable = true;

    networking.networkmanager.enable = true;
    users.users.${user}.extraGroups = [ "networkmanager" ];
  };
}

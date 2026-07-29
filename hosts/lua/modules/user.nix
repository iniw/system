{
  systemModule = { user, ... }: {
    users = {
      mutableUsers = false;

      users.${user} = {
        extraGroups = [ "wheel" ];

        isNormalUser = true;
      };
    };
  };
}

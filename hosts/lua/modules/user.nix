{
  systemModules =
    { user, ... }:
    {
      users.users.${user} = {
        home = "/user/${user}";
        extraGroups = [ "wheel" ];
        isNormalUser = true;
      };
    };
}

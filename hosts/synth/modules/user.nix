{
  systemModule =
    { user, ... }:
    {
      users = {
        users.${user} = {
          uid = 501;
          extraGroups = [
            "wheel"
            "orbstack"
          ];

          # simulate isNormalUser, but with an arbitrary UID
          isSystemUser = true;
          group = "users";
          createHome = true;
          home = "/home/${user}";
          homeMode = "700";
          useDefaultShell = true;
        };

        mutableUsers = false;
      };
    };
}

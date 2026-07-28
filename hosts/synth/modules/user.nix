{
  systemModule =
    { user, ... }:
    {
      users = {
        mutableUsers = false;

        users.${user} = {
          extraGroups = [
            "wheel"
            "orbstack"
            "audio"
          ];

          isNormalUser = true;
        };
      };
    };
}

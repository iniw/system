{
  systemModule =
    { user, ... }:
    {
      users = {
        users.${user} = {
          home = "/Users/${user}";
          uid = 501;
        };
        knownUsers = [ user ];
      };

      system.primaryUser = user;
    };
}

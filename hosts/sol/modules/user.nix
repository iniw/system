{
  systemModule = { user, ... }: {
    users = {
      knownUsers = [ user ];

      users.${user} = {
        home = "/Users/${user}";
        uid = 501;
      };
    };

    system.primaryUser = user;
  };
}

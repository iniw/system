{
  systemModule = { user, ... }: {
    programs = {
      steam.enable = true;

      gamemode = {
        enable = true;

        settings = {
          general.renice = 11;
        };
      };
    };

    users.users.${user}.extraGroups = [ "gamemode" ];
  };
}

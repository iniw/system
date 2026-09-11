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

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    users.users.${user}.extraGroups = [ "gamemode" ];
  };
}

{
  systemModule = { pkgs, user, ... }: {
    programs = {
      steam = {
        enable = true;
        extraPackages = [ pkgs.kdePackages.breeze ];
      };

      gamemode = {
        enable = true;
        settings = {
          general.renice = 10;
        };
      };

      gpu-screen-recorder = {
        enable = true;
        ui.enable = true;
      };
    };

    users.users.${user}.extraGroups = [ "gamemode" ];
  };

  homeManagerModule = { osConfig, ... }: {
    xdg.autostart.entries = [
      "${osConfig.programs.gpu-screen-recorder.ui.package}/share/applications/gpu-screen-recorder.desktop"
    ];
  };
}

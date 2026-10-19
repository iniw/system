{
  systemModule = { user, ... }: {
    virtualisation.docker = {
      enable = true;

      # Pod logs only work with `json-file`. The NixOS default is `journald`.
      logDriver = "json-file";
      daemon.settings.log-opts = {
        max-size = "10m";
        max-file = "3";
      };
    };

    users.users.${user}.extraGroups = [ "docker" ];
  };

  homeManagerModule = { pkgs, ... }: {
    home.packages = [ pkgs.kubectl ];

    xdg.autostart.entries = [ "${pkgs.slack}/share/applications/slack.desktop" ];
  };
}

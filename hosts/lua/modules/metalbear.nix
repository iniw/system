{
  systemModule = {
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };

    systemd.services."user@".serviceConfig.Delegate = "cpu cpuset io memory pids";
  };

  homeManagerModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      k3d
      kubectl
    ];

    xdg.autostart.entries = [ "${pkgs.slack}/share/applications/slack.desktop" ];
  };
}

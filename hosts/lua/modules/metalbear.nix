{
  systemModule = { config, user, ... }: {
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

    services.k3s = {
      enable = true;

      disable = [
        # Ingress controller, which steals ports 80 and 443 on the host.
        "traefik"
      ];

      extraFlags = [
        # Run pods with Docker, so pods can use images from `docker build`.
        "--docker"
        # kubectl creates lock files next to each kubeconfig, so it must be in a folder the user can write to.
        "--write-kubeconfig=${config.users.users.${user}.home}/.kube/k3s.yaml"
        # Let members of the docker group read the kubeconfig.
        "--write-kubeconfig-group=docker"
        "--write-kubeconfig-mode=0640"
      ];
    };
  };

  homeManagerModule = { pkgs, ... }: {
    home = {
      packages = [ pkgs.kubectl ];

      sessionVariables.KUBECONFIG = "$HOME/.kube/config:$HOME/.kube/k3s.yaml";
    };

    xdg.autostart.entries = [ "${pkgs.slack}/share/applications/slack.desktop" ];
  };
}

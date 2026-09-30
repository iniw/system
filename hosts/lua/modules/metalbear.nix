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

        # Give all pods together about 4 cores and 4 GiB. Kubernetes keeps the rest of the machine (32 cores, 30.75 GiB
        # of memory) for the desktop and enforces the limit. The eviction threshold below also takes some memory, so
        # pods get 30.75 - 26.25 - 0.5 = 4 GiB.
        "--kubelet-arg=system-reserved=cpu=28,memory=26880Mi"
        # Stop pods early, before the machine runs out of memory or disk.
        "--kubelet-arg=eviction-hard=memory.available<500Mi,nodefs.available<10%,imagefs.available<10%"
        # The default is 110, which is more than local work needs.
        "--kubelet-arg=max-pods=50"
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

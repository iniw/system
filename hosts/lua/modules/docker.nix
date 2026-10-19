{
  systemModule = { ... }: {
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings.storage-driver = "btrfs";
    };

    # kind needs every cgroup controller, and with rootless Docker it only gets the ones that systemd delegates to the
    # user. See https://kind.sigs.k8s.io/docs/user/rootless/.
    systemd.services."user@".serviceConfig.Delegate = "yes";
  };
}

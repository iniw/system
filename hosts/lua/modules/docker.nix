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

    # New network namespaces copy their IPv4 settings from the host, so with forwarding off here, kind creates every pod
    # interface with forwarding off and pods can't reach each other, CoreDNS or the internet. Rootful Docker turns this
    # on by itself, but rootless Docker can't.
    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  };
}

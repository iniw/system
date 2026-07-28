{
  systemModule = {
    # Disable systemd-resolved
    services.resolved.enable = false;
    networking.resolvconf.enable = false;
    environment.etc."resolv.conf".source = "/opt/orbstack-guest/etc/resolv.conf";

    networking.hostName = "synth";

    networking.dhcpcd.enable = false;
    networking.useDHCP = false;

    systemd.network = {
      enable = true;
      networks."50-eth0" = {
        matchConfig.Name = "eth0";
        networkConfig = {
          DHCP = "ipv4";
          IPv6AcceptRA = true;
        };
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}

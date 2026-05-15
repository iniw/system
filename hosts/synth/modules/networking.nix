{
  systemModule = {
    networking = {
      dhcpcd.enable = false;
      resolvconf.enable = false;
      useDHCP = false;
      hostName = "synth";
    };

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

    # Extra certificates from OrbStack.
    security.pki.certificates = [
      ''
              -----BEGIN CERTIFICATE-----
        MIICDDCCAbOgAwIBAgIRAK9Qw8vk7Z92u91AA+OBP0swCgYIKoZIzj0EAwIwZjEd
        MBsGA1UEChMUT3JiU3RhY2sgRGV2ZWxvcG1lbnQxHjAcBgNVBAsMFUNvbnRhaW5l
        cnMgJiBTZXJ2aWNlczElMCMGA1UEAxMcT3JiU3RhY2sgRGV2ZWxvcG1lbnQgUm9v
        dCBDQTAeFw0yNjAzMDIxMzIyMTVaFw0zNjAzMDIxMzIyMTVaMGYxHTAbBgNVBAoT
        FE9yYlN0YWNrIERldmVsb3BtZW50MR4wHAYDVQQLDBVDb250YWluZXJzICYgU2Vy
        dmljZXMxJTAjBgNVBAMTHE9yYlN0YWNrIERldmVsb3BtZW50IFJvb3QgQ0EwWTAT
        BgcqhkjOPQIBBggqhkjOPQMBBwNCAARdcnYMGkXyyYBmQrrEDvjCMcGGuPQlFpj0
        PV4jdRJ2w6qRrubT4ZGpMPyEWGFOHlct+W5f4/oJNYy+LTwXcSTho0IwQDAOBgNV
        HQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQU23rfyvoT4dIi
        WJE11FOvPiHtUp4wCgYIKoZIzj0EAwIDRwAwRAIgQ2IMpzr/h4KJU4bC7R9OI2/0
        +J1rbzzySIfpqhOmY7wCIFneThTdBRlk6MRQycc47KC/SnpdwkW3Y3GjyVu71ZYL
        -----END CERTIFICATE-----

      ''
    ];
  };
}

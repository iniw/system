{
  systemModule =
    { lib, ... }:
    {
      # Add OrbStack CLI tools to PATH
      environment.shellInit = ''
        . /opt/orbstack-guest/etc/profile-early
        . /opt/orbstack-guest/etc/profile-late
      '';

      systemd.services =
        lib.genAttrs
          [
            "systemd-oomd"
            "systemd-userdbd"
            "systemd-udevd"
            "systemd-timesyncd"
            "systemd-timedated"
            "systemd-portabled"
            "systemd-nspawn@"
            "systemd-machined"
            "systemd-localed"
            "systemd-logind"
            "systemd-journald@"
            "systemd-journald"
            "systemd-journal-remote"
            "systemd-journal-upload"
            "systemd-importd"
            "systemd-hostnamed"
            "systemd-homed"
            "systemd-networkd"
          ]
          (_: {
            serviceConfig.WatchdogSec = 0;
          });

      users.groups.orbstack.gid = 67278;
    };
}

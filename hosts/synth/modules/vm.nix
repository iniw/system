{
  systemModule =
    { pkgs, ... }:
    {
      virtualisation.vmware.guest.enable = true;

      systemd.tmpfiles.rules = [
        "d /host 0755 root root -"
      ];

      systemd.services.vmware-shared-folder = {
        description = "VMware shared folder";

        after = [ "vmware.service" ];
        wantedBy = [ "multi-user.target" ];

        unitConfig.ConditionVirtualization = "vmware";

        serviceConfig = {
          ExecStart = "${pkgs.lib.getExe' pkgs.open-vm-tools "vmhgfs-fuse"} .host:/vini /host -o allow_other,uid=1000,gid=100";
          ExecStop = "${pkgs.lib.getExe' pkgs.util-linux "umount"} /host";

          Type = "oneshot";
          RemainAfterExit = true;
        };
      };
    };
}

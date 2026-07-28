{
  systemModule = {
    services.openssh.enable = false;
    programs.ssh.extraConfig = ''
      Include /opt/orbstack-guest/etc/ssh_config
    '';
  };
}

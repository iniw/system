{
  # Nicotine+ keeps its listening port in ~/.config/nicotine/config (`portrange`), so the port here must match it.
  # The router forwards the same port to this host.
  systemModule = {
    networking.firewall.allowedTCPPorts = [ 2234 ];
  };

  homeManagerModule = { pkgs, ... }: {
    home.packages = [ pkgs.nicotine-plus ];
  };
}

{
  systemModule = {
    networking = {
      hostName = "synth";
      wireless.enable = true;
      networkmanager.enable = true;
    };

    services.tailscale.enable = true;
  };
}

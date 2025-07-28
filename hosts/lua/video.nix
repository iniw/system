{ config, ... }:
{
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  hardware = {
    graphics.enable = true;

    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}

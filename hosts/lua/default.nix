sys:
sys.nixosSystem (
  { config, user, ... }:
  {
    imports = [ ./hardware.nix ];

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    time.timeZone = "America/Sao_Paulo";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      inputMethod = {
        enable = true;
        type = "ibus";
      };
    };

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

    system.stateVersion = "25.05";
  }
)

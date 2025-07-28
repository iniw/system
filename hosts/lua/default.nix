{
  name,
  inputs,
  sys,
}:
{
  nixosConfigurations.${name} = sys.nixosSystem {
    inherit (inputs.nixpkgs) lib;
    system = "x86_64-linux";
    module =
      { user, config, ... }:
      {
        imports = [ ./hardware.nix ];

        boot.loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };

        time.timeZone = "America/Sao_Paulo";

        users.users.${user}.extraGroups = [ "networkmanager" ];
        networking.networkmanager.enable = true;

        home-manager.users.${user} =
          { lib, ... }:
          {
            home.stateVersion = "25.05";

            dconf = {
              settings = {
                "org/gnome/desktop/input-sources".sources = [
                  (lib.hm.gvariant.mkTuple [
                    "xkb"
                    "br"
                  ])
                ];

                "org/gnome/desktop/peripherals/mouse".speed = -0.20;
              };
            };
          };

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
      };
  };
}

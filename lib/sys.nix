{ lib, inputs }:
let
  modules =
    builtins.readDir ../modules
    |> lib.mapAttrs (name: _: import ../modules/${name})
    |> lib.attrValues
    |> lib.zipAttrs
    |> lib.mapAttrs' (name: values: lib.nameValuePair "${name}s" values);

  fromInputs =
    let
      collectInputs =
        path:
        inputs
        |> lib.attrValues
        |> lib.filter (lib.hasAttrByPath path)
        |> lib.map (lib.getAttrFromPath path);
    in
    {
      darwinModules = collectInputs [
        "darwinModules"
        "default"
      ];

      nixosModules = collectInputs [
        "nixosModules"
        "default"
      ];

      homeModules = collectInputs [
        "homeManagerModules"
        "default"
      ];

      overlays = collectInputs [
        "overlays"
        "default"
      ];
    };

  user = "vini";

  specialArgs = {
    inherit user inputs;
  };

  commonModules =
    let
      homeManager =
        { pkgs, ... }:
        {
          home-manager = {
            users.${user} = {
              imports = fromInputs.homeModules ++ modules.homeModules or [ ];

              xdg.enable = true;
            };

            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = specialArgs // {
              pkgs-unstable = import inputs.nixpkgs-unstable {
                inherit (pkgs) system config;
              };
            };

            backupFileExtension = "hm-backup";
          };
        };

      nixSettings = {
        nixpkgs = {
          overlays = fromInputs.overlays;
          config.allowUnfree = true;
        };

        nix.settings.trusted-users = [ user ];
      };
    in
    [
      homeManager
      nixSettings
    ];

in
{
  darwinSystem =
    let
      userConfigModule = {
        users = {
          users.${user} = {
            uid = 501;
            home = "/Users/${user}";
          };
          knownUsers = [ user ];
        };

        system.primaryUser = user;

        home-manager.users.${user}.imports = modules.darwinHomeModules or [ ];
      };

      homebrewModule =
        let
          taps = {
            "homebrew/homebrew-core" = inputs.homebrew-core;
            "homebrew/homebrew-cask" = inputs.homebrew-cask;
          };
        in
        {
          imports = [
            inputs.nix-homebrew.darwinModules.nix-homebrew
          ];

          nix-homebrew = {
            enable = true;
            inherit user taps;
            mutableTaps = false;
          };

          homebrew = {
            enable = true;
            global.autoUpdate = false;
            # The `cleanup = "zap"` field causes brew to try untapping taps that don't appear in the brewfile bundle,
            # so we repeat them here just to get them in the brewfile.
            # See also: https://github.com/zhaofengli/nix-homebrew/issues/5
            taps = builtins.attrNames taps;
            onActivation.cleanup = "zap";
          };
        };
    in
    {
      lib,
      system,
      module,
    }:
    lib.darwinSystem {
      inherit system specialArgs;

      modules =
        commonModules
        ++ fromInputs.darwinModules
        ++ modules.systemModules or [ ]
        ++ modules.darwinSystemModules or [ ]
        ++ [
          module
          userConfigModule
          homebrewModule
        ];
    };

  nixosSystem =
    let
      userConfigModule = {
        users.users.${user} = {
          extraGroups = [ "wheel" ];
          home = "/user/${user}";
          isNormalUser = true;
        };

        home-manager.users.${user}.imports = modules.nixosHomeModules or [ ];
      };
    in
    {
      lib,
      system,
      module,
    }:
    lib.nixosSystem {
      inherit system specialArgs;

      modules =
        commonModules
        ++ fromInputs.nixosModules
        ++ modules.systemModules or [ ]
        ++ modules.nixosSystemModules or [ ]
        ++ [
          module
          userConfigModule
        ];
    };
}

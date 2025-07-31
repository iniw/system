inputs:
let
  lib = inputs.nixpkgs.lib;

  modules =
    lib.filesystem.listFilesRecursive ../modules
    |> lib.filter (lib.hasSuffix ".nix")
    |> lib.map (import)
    |> lib.zipAttrs
    |> lib.mapAttrs' (name: lib.nameValuePair "${name}s");

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
            home = "/Users/${user}";
            uid = 501;
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
            taps = lib.attrNames taps;
            onActivation.cleanup = "zap";
          };
        };
    in
    module: name: {
      darwinConfigurations.${name} = inputs.nix-darwin.lib.darwinSystem {
        inherit specialArgs;

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
    };

  nixosSystem =
    let
      userConfigModule = {
        users.users.${user} = {
          home = "/user/${user}";
          extraGroups = [ "wheel" ];
          isNormalUser = true;
        };

        home-manager.users.${user}.imports = modules.nixosHomeModules or [ ];
      };
    in
    module: name: {
      nixosConfigurations.${name} = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;

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
    };
}

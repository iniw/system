inputs:
let
  lib = inputs.nixpkgs.lib;

  collectModules =
    path:
    if builtins.pathExists path then
      (lib.filesystem.listFilesRecursive path)
      |> lib.filter (lib.hasSuffix ".nix")
      |> lib.map (import)
      |> lib.zipAttrs
      |> lib.mapAttrs' (name: lib.nameValuePair "${name}s")
    else
      { };

  modules = collectModules ../modules;
  collectHostModules = host: collectModules (../hosts + "/${host}/modules");

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
    host:
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
                inherit (pkgs) system config overlays;
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
      (import (../hosts + "/${host}/hardware.nix"))
    ];

in
{
  darwinSystem =
    let
      homebrewModule =
        let
          taps = {
            "homebrew/homebrew-core" = inputs.homebrew-core;
            "homebrew/homebrew-cask" = inputs.homebrew-cask;
          };
        in
        {
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
    module: host:
    let
      hostModules = collectHostModules host;

      userConfigModule = {
        users = {
          users.${user} = {
            home = "/Users/${user}";
            uid = 501;
          };
          knownUsers = [ user ];
        };

        system.primaryUser = user;

        home-manager.users.${user}.imports =
          (modules.darwinHomeModules or [ ]) ++ (hostModules.homeModules or [ ]);
      };
    in
    {
      darwinConfigurations.${host} = inputs.nix-darwin.lib.darwinSystem {
        inherit specialArgs;

        modules =
          (commonModules host)
          ++ fromInputs.darwinModules
          ++ (modules.systemModules or [ ])
          ++ (modules.darwinSystemModules or [ ])
          ++ (hostModules.systemModules or [ ])
          ++ [
            module
            userConfigModule
            homebrewModule
          ];
      };
    };

  nixosSystem =
    module: host:
    let
      hostModules = collectHostModules host;

      userConfigModule = {
        users.users.${user} = {
          home = "/user/${user}";
          extraGroups = [ "wheel" ];
          isNormalUser = true;
        };

        home-manager.users.${user}.imports =
          (modules.nixosHomeModules or [ ]) ++ (hostModules.homeModules or [ ]);
      };
    in
    {
      nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        modules =
          (commonModules host)
          ++ fromInputs.nixosModules
          ++ (modules.systemModules or [ ])
          ++ (modules.nixosSystemModules or [ ])
          ++ (hostModules.systemModules or [ ])
          ++ [
            module
            userConfigModule
          ];
      };
    };
}

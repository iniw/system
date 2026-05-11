inputs:
let
  lib = inputs.nixpkgs.lib;

  modules =
    let
      collectModules =
        path:
        path
        |> builtins.readDir
        |> lib.mapAttrsToList (name: _: import (path + "/${name}"))
        |> lib.zipAttrs
        |> lib.mapAttrs' (name: lib.nameValuePair "${name}s");
    in
    {
      common = collectModules ../modules;
      forHost = host: collectModules (../hosts + "/${host}/modules");
    };

  user = "vini";

  specialArgs = {
    inherit user inputs;
  };
in
{
  darwinSystem =
    module: host:
    let
      hostModules = modules.forHost host;

      homeManagerImports = {
        home-manager.users.${user}.imports =
          (modules.common.homeManagerModules or [ ])
          ++ (hostModules.homeManagerModules or [ ])
          ++ (modules.common.darwinHomeManagerModules or [ ]);
      };
    in
    {
      darwinConfigurations.${host} = inputs.nix-darwin.lib.darwinSystem {
        inherit specialArgs;

        modules =
          (modules.common.systemModules or [ ])
          ++ (hostModules.systemModules or [ ])
          ++ (modules.common.darwinSystemModules or [ ])
          ++ [
            module
            homeManagerImports
            inputs.home-manager.darwinModules.home-manager
          ];
      };
    };

  nixosSystem =
    module: host:
    let
      hostModules = modules.forHost host;

      homeManagerImports = {
        home-manager.users.${user}.imports =
          (modules.common.homeManagerModules or [ ])
          ++ (hostModules.homeManagerModules or [ ])
          ++ (modules.common.nixosHomeManagerModules or [ ]);
      };
    in
    {
      nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        modules =
          (modules.common.systemModules or [ ])
          ++ (hostModules.systemModules or [ ])
          ++ (modules.common.nixosSystemModules or [ ])
          ++ [
            module
            homeManagerImports
            inputs.home-manager.nixosModules.home-manager
          ];
      };
    };
}

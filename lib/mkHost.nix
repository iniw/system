inputs:
let
  inherit (inputs.nixpkgs) lib;

  modules =
    let
      collectModules =
        path:
        lib.readDir path
        |> lib.mapAttrsToList (name: _: import "${path}/${name}")
        |> lib.zipAttrs
        |> lib.mapAttrs' (name: lib.nameValuePair "${name}s");
    in
    {
      common = collectModules "${inputs.self}/modules";
      forHost = host: collectModules "${inputs.self}/hosts/${host}/modules";
    };

  user = "vini";

  specialArgs = hostName: {
    inherit inputs user hostName;
  };
in
{
  darwinSystem =
    mainModule: host:
    let
      hostModules = modules.forHost host;

      homeManagerModule = {
        imports = [ inputs.home-manager.darwinModules.home-manager ];
        home-manager.users.${user}.imports =
          (modules.common.homeManagerModules or [ ])
          ++ (hostModules.homeManagerModules or [ ])
          ++ (modules.common.darwinHomeManagerModules or [ ]);
      };
    in
    {
      darwinConfigurations.${host} = inputs.nix-darwin.lib.darwinSystem {
        specialArgs = specialArgs host;

        modules =
          (modules.common.systemModules or [ ])
          ++ (hostModules.systemModules or [ ])
          ++ (modules.common.darwinSystemModules or [ ])
          ++ [
            mainModule
            homeManagerModule
          ];
      };
    };

  nixosSystem =
    mainModule: host:
    let
      hostModules = modules.forHost host;

      homeManagerModule = {
        imports = [ inputs.home-manager.nixosModules.home-manager ];
        home-manager.users.${user}.imports =
          (modules.common.homeManagerModules or [ ])
          ++ (hostModules.homeManagerModules or [ ])
          ++ (modules.common.nixosHomeManagerModules or [ ]);
      };
    in
    {
      nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs host;

        modules =
          (modules.common.systemModules or [ ])
          ++ (hostModules.systemModules or [ ])
          ++ (modules.common.nixosSystemModules or [ ])
          ++ [
            mainModule
            homeManagerModule
          ];
      };
    };
}

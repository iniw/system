{
  description = "system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, mac-app-util }:
    let
      user = "sol";
      host = "mac";
    in
    {
      darwinConfigurations.${host} = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        specialArgs = { inherit user; };
        modules = [
          ./configuration.nix

          mac-app-util.darwinModules.default

          home-manager.darwinModules.home-manager
          {
            users.users.${user} = {
              name = user;
              home = "/Users/${user}/";
            };

            home-manager = {
              extraSpecialArgs = { inherit user; };

              useGlobalPkgs = true;
              useUserPackages = true;

              users.${user}.imports = [
                ./home.nix

                mac-app-util.homeManagerModules.default
              ];
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.${host}.pkgs;
    };
}

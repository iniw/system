{
  description = "system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util.url = "github:hraban/mac-app-util";

    # provides the latest build of Zellij until a release truly
    # fixes https://github.com/zellij-org/zellij/issues/3208
    zellij = {
      url = "github:a-kenji/zellij-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      mac-app-util,
      zellij,
    }:

    let
      user = "sol";
      host = "mac";

      overlay = final: prev: { zellij-latest = zellij.packages."${prev.system}".zellij; };
      overlayModule = (
        { ... }:
        {
          nixpkgs.overlays = [ overlay ];
        }
      );
    in
    {
      darwinConfigurations.${host} = nix-darwin.lib.darwinSystem rec {
        system = "x86_64-darwin";

        specialArgs = {
          inherit user;
        };

        modules = [
          overlayModule

          ./configuration.nix

          mac-app-util.darwinModules.default

          home-manager.darwinModules.home-manager
          {
            users.users.${user} = {
              name = user;
              home = "/Users/${user}";
            };

            home-manager = {
              extraSpecialArgs = {
                pkgs-unstable = import nixpkgs-unstable { inherit system; };
                inherit user;
              };

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

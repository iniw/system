{
  description = "system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      mac-app-util,
    }:

    let
      user = "sol";
    in
    {
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";

        specialArgs = {
          inherit self;
          inherit user;
          inherit mac-app-util;
        };

        modules = [
          ./configuration/darwin.nix
          home-manager.darwinModules.home-manager
          mac-app-util.darwinModules.default
        ];
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit self;
          inherit user;
        };

        modules = [
          ./configuration/nixos
          home-manager.nixosModules.home-manager
        ];
      };
    };
}

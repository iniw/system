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

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    klip = {
      url = "github:iniw/klip";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      mac-app-util,
      klip,
      ghostty,
    }:

    let
      user = "sol";
      overlay = final: prev: {
        klip = klip.packages."${prev.system}".klip;
        ghostty = ghostty.packages."${prev.system}".ghostty;
      };
    in
    {
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";

        specialArgs = {
          inherit user;
          inherit mac-app-util;
          inherit overlay;
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
          inherit user;
          inherit overlay;
        };

        modules = [
          ./configuration/nixos
          home-manager.nixosModules.home-manager
        ];
      };
    };
}

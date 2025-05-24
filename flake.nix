{
  description = "system flake";

  inputs = {
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-nixos";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    klip = {
      url = "github:iniw/klip";
      inputs.nixpkgs.follows = "nixpkgs-nixos";
    };

    fonts = {
      url = "git+ssh://git@github.com/iniw/fonts";
      inputs.nixpkgs.follows = "nixpkgs-nixos";
    };
  };

  outputs =
    {
      self,
      nixpkgs-darwin,
      nixpkgs-nixos,
      nixpkgs-unstable,
      nix-darwin,
      home-manager,
      mac-app-util,
      klip,
      fonts,
    }:

    let
      user = "sol";

      overlays = [
        klip.overlays.default
        fonts.overlays.default
      ];
    in
    {
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem rec {
        system = "x86_64-darwin";

        specialArgs = {
          inherit
            user
            overlays
            mac-app-util
            ;
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
        };

        modules = [
          ./configuration/darwin.nix
          home-manager.darwinModules.home-manager
          mac-app-util.darwinModules.default
        ];
      };

      nixosConfigurations.nixos = nixpkgs-nixos.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          inherit user overlays;
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
        };

        modules = [
          ./configuration/nixos
          home-manager.nixosModules.home-manager
        ];
      };
      # julia + vinicius = amor
    };
}

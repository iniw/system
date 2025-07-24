{
  description = "wini's system flake";

  inputs = {
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    klip = {
      url = "github:iniw/klip";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    fonts = {
      url = "git+ssh://git@github.com/iniw/fonts";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs =
    inputs:
    let
      user = "sol";

      overlays = [
        inputs.klip.overlays.default
        inputs.fonts.overlays.default
      ];
    in
    {
      darwinConfigurations.mac = inputs.nix-darwin.lib.darwinSystem rec {
        system = "x86_64-darwin";

        specialArgs = {
          inherit
            user
            overlays
            inputs
            ;
          pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
        };

        modules = [
          ./configuration/darwin.nix
          inputs.home-manager.darwinModules.home-manager
          inputs.mac-app-util.darwinModules.default
          inputs.nix-homebrew.darwinModules.nix-homebrew
        ];
      };

      nixosConfigurations.nixos = inputs.nixpkgs-nixos.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          inherit user overlays inputs;
          pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
        };

        modules = [
          ./configuration/nixos
          inputs.home-manager.nixosModules.home-manager
        ];
      };
      # julia + vinicius = amor
    };
}

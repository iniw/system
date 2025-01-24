{
  description = "system flake";

  inputs = {
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    klip = {
      url = "github:iniw/klip";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs-unstable.follows = "nixpkgs-nixos";
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
      ghostty,
    }:

    let
      darwin-system = "x86_64-darwin";
      nixos-system = "x86_64-linux";
      user = "sol";

      overlay = final: prev: {
        klip = klip.packages."${prev.system}".klip;
        ghostty = ghostty.packages."${prev.system}".ghostty;
      };

      devShell =
        pkgs:
        with pkgs;
        mkShell {
          packages = [
            lua-language-server
            stylua
          ];
        };
    in
    {
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem rec {
        system = darwin-system;

        specialArgs = {
          inherit user overlay mac-app-util;
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
        };

        modules = [
          ./configuration/darwin.nix
          home-manager.darwinModules.home-manager
          mac-app-util.darwinModules.default
        ];
      };

      nixosConfigurations.nixos = nixpkgs-nixos.lib.nixosSystem rec {
        system = nixos-system;

        specialArgs = {
          inherit user overlay;
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
        };

        modules = [
          ./configuration/nixos
          home-manager.nixosModules.home-manager
        ];
      };

      devShells.${darwin-system}.default = devShell (import nixpkgs-darwin { system = darwin-system; });
      devShells.${nixos-system}.default = devShell (import nixpkgs-nixos { system = nixos-system; });
    };
}

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

    minimal-tmux = {
      url = "github:niksingh710/minimal-tmux-status";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      mac-app-util,
      minimal-tmux,
    }:

    let
      user = "sol";
    in
    {
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem rec {
        system = "x86_64-darwin";

        specialArgs = {
          inherit user;
        };

        modules = [
          ./configuration/darwin.nix

          mac-app-util.darwinModules.default

          home-manager.darwinModules.home-manager
          {
            users.users.${user} = {
              name = user;
              home = "/Users/${user}";
            };

            home-manager = {
              extraSpecialArgs = {
                inherit user;
                inherit minimal-tmux;
              };

              useGlobalPkgs = true;
              useUserPackages = true;

              users.${user}.imports = [
                ./home/darwin.nix
                mac-app-util.homeManagerModules.default
              ];
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.mac.pkgs;

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          inherit user;
        };

        modules = [
          ./configuration/nixos

          home-manager.nixosModules.home-manager

          {
            users.users.${user} = {
              name = user;
              home = "/home/${user}";
              isNormalUser = true;
              extraGroups = [ "wheel" ];
            };

            home-manager = {
              extraSpecialArgs = {
                inherit user;
                inherit minimal-tmux;
              };

              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user}.imports = [ ./home/nixos.nix ];
            };
          }
        ];
      };
    };
}

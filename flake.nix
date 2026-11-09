{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    mitos = {
      url = "github:mitos-editor/mitos/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jj-gh = {
      url = "github:mrjones2014/jj-gh/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nprt = {
      url = "github:thatsneat-dev/nprt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;

      hosts =
        let
          sys = import ./lib/sys.nix inputs;
        in
        lib.readDir ./hosts
        |> lib.mapAttrsToList (host: _: import ./hosts/${host} sys host)
        |> lib.foldr lib.recursiveUpdate { };

      forAllSystems =
        f: lib.genAttrs lib.systems.flakeExposed (system: f inputs.nixpkgs.legacyPackages.${system});
    in
    {
      inherit (hosts) darwinConfigurations nixosConfigurations;

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            dix
            nix-update
          ];
        };
      });

      packages = forAllSystems (
        pkgs:
        {
          # Packages maintained locally because they are not available in nixpkgs yet.
          # I may eventually upstream them.
          #
          # Accessing from a module:
          #   inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.<package>
          #
          # Updating:
          #   nix-update <package> --flake

          linear-cli = pkgs.callPackage ./pkgs/linear-cli.nix { };
          slackcli = pkgs.callPackage ./pkgs/slackcli.nix { };
        }
        // lib.optionalAttrs (pkgs.stdenv.hostPlatform.isDarwin) {
          seeleseek = pkgs.callPackage ./pkgs/seeleseek.nix { };
          space-rabbit = pkgs.callPackage ./pkgs/space-rabbit.nix { };
        }
      );
    };
}

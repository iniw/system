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

    fonts = {
      url = "git+ssh://git@git.sr.ht/~wini/fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:iniw/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-pr-tracker = {
      url = "github:thatsneat-dev/nprt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;

      hosts =
        let
          mkHost = import ./lib/mkHost.nix inputs;
        in
        lib.readDir ./hosts
        |> lib.mapAttrsToList (host: _: import ./hosts/${host} mkHost host)
        |> lib.foldr lib.recursiveUpdate { };
    in
    {
      inherit (hosts) darwinConfigurations nixosConfigurations;

      devShells = lib.genAttrs lib.systems.flakeExposed (
        system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            # Everything needed to bootstrap the config with `./x`
            packages = with pkgs; [
              git
              nh
              nushell
            ];
          };
        }
      );
    };
}

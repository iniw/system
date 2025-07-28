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
      lib = inputs.nixpkgs-unstable.lib;
      sys = import ./lib/sys.nix {
        inherit inputs lib;
      };

      configurations =
        builtins.readDir ./hosts
        |> lib.mapAttrsToList (name: _: import ./hosts/${name} { inherit name inputs sys; })
        |> lib.mergeAttrsList;

    in
    configurations;
}

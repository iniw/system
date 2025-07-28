{
  description = "wini's system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    klip = {
      url = "github:iniw/klip";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fonts = {
      url = "git+ssh://git@github.com/iniw/fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.nixpkgs.lib;
      sys = import ./lib/sys.nix { inherit lib inputs; };

      configurations =
        builtins.readDir ./hosts
        |> lib.mapAttrsToList (name: _: import ./hosts/${name} { inherit name inputs sys; })
        |> lib.mergeAttrsList;
    in
    configurations;
}

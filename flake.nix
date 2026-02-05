{
  description = "wini's system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # FIXME: Clone the normal repo once https://github.com/zhaofengli/nix-homebrew/pull/119 is merged
    nix-homebrew.url = "github:zhaofengli/nix-homebrew?ref=pull/119/merge";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    fonts = {
      url = "git+ssh://git@git.sr.ht/~wini/fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:iniw/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code-overlay = {
      url = "github:ryoppippi/claude-code-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.nixpkgs.lib;
      sys = import ./lib/sys.nix inputs;

      configurations =
        ./hosts
        |> builtins.readDir
        |> lib.mapAttrsToList (name: _: import ./hosts/${name} sys name)
        |> lib.foldr lib.recursiveUpdate { };
    in
    configurations;
}

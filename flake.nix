{
  description = "wini's system flake";

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

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
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

      sys = import ./lib/sys.nix inputs;

      configurations =
        builtins.readDir ./hosts
        |> lib.mapAttrsToList (name: _: import ./hosts/${name} sys name)
        |> lib.foldr lib.recursiveUpdate { };
    in
    configurations;
}

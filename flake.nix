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
      # Access is granted by the `secrets/bootstrap.age` deploy key.
      url = "git+ssh://git@github.com/iniw/fonts";
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

      forAllSystems =
        f: lib.genAttrs lib.systems.flakeExposed (system: f inputs.nixpkgs.legacyPackages.${system});
    in
    {
      inherit (hosts) darwinConfigurations nixosConfigurations;

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nh
            nushell
          ];
        };
      });

      packages = forAllSystems (pkgs: {
        bootstrap = pkgs.writeShellApplication {
          name = "system-bootstrap";

          runtimeInputs = with pkgs; [
            age
            git
            nh
            nushell
            openssh
          ];

          text = ''
            ssh_key="$(mktemp)"
            age --decrypt ${inputs.self}/secrets/bootstrap.age > "$ssh_key"
            chmod 600 "$ssh_key"

            GIT_SSH_COMMAND="ssh -o IdentityAgent=none -i '$ssh_key'" \
              ${inputs.self}/x switch "$@"
          '';
        };
      });
    };
}

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

    nprt = {
      url = "github:thatsneat-dev/nprt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jj-gh = {
      url = "github:mrjones2014/jj-gh";
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
            nh
            nix-update
          ];
        };
      });

      packages = forAllSystems (pkgs: {
        # Allows easily bootstrapping the config on a fresh system with nothing but nix installed:
        # nix --extra-experimental-features "flakes nix-command pipe-operators" run github:iniw/system#bootstrap -- -H $host
        bootstrap = pkgs.writeShellApplication {
          name = "bootstrap";

          runtimeInputs = with pkgs; [
            age
            git
            openssh
            nh
          ];

          runtimeEnv = {
            # We're bootstrapping the configuration so we can't guarantee
            # that the experimental features are present in the system's nix config
            NIX_CONFIG = "extra-experimental-features = flakes nix-command pipe-operators";
          };

          text = ''
            # Decrypt and tell git to use the bootstrap SSH key
            bootstrap_key="$(mktemp)"
            age --decrypt "${inputs.self}/secrets/bootstrap.age" > "$bootstrap_key"
            export GIT_SSH_COMMAND="ssh -i '$bootstrap_key'"

            case "$(uname -s)" in
              Darwin) os=darwin ;;
              Linux) os=os ;;
              *) echo "unsupported os: $(uname -s)" >&2; exit 1 ;;
            esac

            nh "$os" switch "path:${inputs.self}" "$@"
          '';
        };

        # Packages maintained locally because they are not available in nixpkgs yet.
        # I may eventually upstream them.
        #
        # Accessing from a module:
        #   inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.<package>
        #
        # Updating:
        #   nix-update <package> --flake

        seeleseek = pkgs.callPackage ./pkgs/seeleseek.nix { };
        space-rabbit = pkgs.callPackage ./pkgs/space-rabbit.nix { };
      });
    };
}

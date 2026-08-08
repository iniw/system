{
  systemModule = {
    nixpkgs.overlays = [
      (final: prev: {
        # https://github.com/NixOS/nixpkgs/pull/548703
        orbstack = prev.orbstack.overrideAttrs {
          version = "2.2.3-20963";
          src = final.fetchurl {
            url = "https://cdn-updates.orbstack.dev/arm64/OrbStack_v2.2.3_20963_arm64.dmg";
            hash = "sha256-fKd4aPOg19n1ez+YYVqtMMxZ0jzIS7/xP3iEbfC0k9Q=";
          };
        };
      })
    ];
  };

  homeManagerModule = { pkgs, ... }: {
    home.packages = [ pkgs.orbstack ];
    programs.ssh.includes = [ "~/.orbstack/ssh/config" ];
  };
}

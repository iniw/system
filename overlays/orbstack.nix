final: prev: {
  orbstack =
    let
      inherit (final.stdenvNoCC.hostPlatform) system;
      version = "2.1.3-20115";
      sourceData = {
        aarch64-darwin = {
          arch = "arm64";
          hash = "sha256-9JTbgE/Ehu8viOq5A9GGpph8eG3jmGj/iDQWpeuacxc=";
        };
        x86_64-darwin = {
          arch = "amd64";
          hash = "sha256-Wi76W+z5Xs66gjtyxUZIo+K3ziHb3GAn83k7k5Xopjk=";
        };
      };
      sources = final.lib.mapAttrs (
        system:
        { arch, hash }:
        final.fetchurl {
          url = "https://cdn-updates.orbstack.dev/${arch}/OrbStack_v${
            final.lib.replaceString "-" "_" version
          }_${arch}.dmg";
          inherit hash;
        }
      ) sourceData;
    in
    prev.orbstack.overrideAttrs {
      inherit version;
      src = sources.${system} or (throw "unsupported system ${system}");
    };
}

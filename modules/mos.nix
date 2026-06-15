{
  systemModule = {
    nixpkgs.overlays = [
      (final: prev: {
        mos = prev.mos.overrideAttrs rec {
          version = "4.2.1";
          src = final.fetchurl {
            url = "https://github.com/Caldis/Mos/releases/download/${version}/Mos.Versions.${version}-20260531.1.zip";
            hash = "sha256-LqaelvCS5E2tqTpVvaHN2rMynFJ7vV8G4A37eOlTlgo=";
          };
        };
      })
    ];
  };
}

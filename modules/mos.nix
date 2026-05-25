{
  systemModule = {
    nixpkgs.overlays = [
      (final: prev: {
        mos = prev.mos.overrideAttrs rec {
          version = "4.2.0";
          src = final.fetchurl {
            url = "https://github.com/Caldis/Mos/releases/download/${version}/Mos.Versions.${version}-20260505.1.zip";
            hash = "sha256-SswAG7V+7LbAbPcHwS4Kr+0TFg6XWhYTEK7lVC3lYCQ=";
          };
        };
      })
    ];
  };
}

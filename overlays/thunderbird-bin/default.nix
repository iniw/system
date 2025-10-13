final: prev: rec {
  thunderbird-bin-unwrapped = final.callPackage ./package {
    generated = import ./package/release_sources.nix;
  };
  thunderbird-bin = final.wrapThunderbird thunderbird-bin-unwrapped { pname = "thunderbird-bin"; };
}

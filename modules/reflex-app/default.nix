{
  systemModule = {
    nixpkgs.overlays = [
      (final: prev: {
        reflex-app = final.callPackage ./package.nix { };
      })
    ];
  };
}

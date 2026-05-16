{
  systemModule = {
    nixpkgs.overlays = [
      (final: prev: {
        linear = final.callPackage ./package.nix { };
      })
    ];
  };
}

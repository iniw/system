final: prev: {
  gtk3 = prev.gtk3.overrideAttrs (previousAttrs: {
    patches = previousAttrs.patches ++ [
      ./clang-tests-sincos.patch
    ];
  });
}

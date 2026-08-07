{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "seeleseek";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/bretth18/seeleseek/releases/download/v${finalAttrs.version}/seeleseek.pkg";
    hash = "sha256-pJO7hTCNPmVJHzIsCL4tT0B3JkhFgAN0wXFBpMj80jE=";
  };

  nativeBuildInputs = [
    xar
    cpio
  ];

  unpackPhase = ''
    runHook preUnpack

    xar -xf "$src"
    zcat seeleseek-component.pkg/Payload | cpio -i

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R seeleseek.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native macOS client for the Soulseek network";
    homepage = "https://seeleseek.net/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wini ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

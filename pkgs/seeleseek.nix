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
  version = "1.9.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/bretth18/seeleseek/releases/download/v${finalAttrs.version}/seeleseek.pkg";
    hash = "sha256-pv9ds/yRNlVEMupEwihzxAjg51arT8/09Uvu3gg7qpo=";
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

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
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/bretth18/seeleseek/releases/download/v${finalAttrs.version}/seeleseek.pkg";
    hash = "sha256-FlDCtc3ys0KfwRz6TPkA27oMbNI0hQ66m01KvJDaG3c=";
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

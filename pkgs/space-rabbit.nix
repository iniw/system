{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "space-rabbit";
  version = "2.5.0";

  src = fetchurl {
    url = "https://github.com/Tahul/space-rabbit/releases/download/v${finalAttrs.version}/Space-Rabbit.dmg";
    hash = "sha256-vKop8Z7j7YEYMTYPDh96i5H6sPsofEZBmTmN/21892o=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R "Space Rabbit.app" "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Remove animations when switching macOS Spaces";
    homepage = "https://space-rabbit.app/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ wini ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

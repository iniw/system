{
  lib,
  fetchurl,
  stdenvNoCC,
  unzip,
}:
let
  platforms = {
    aarch64-darwin = {
      arch = "arm64";
      hash = "sha256-vtxAgJGDWSRzmmyn+JQaTzAJJDzScxh02/I2/xDNiFg=";
    };
    x86_64-darwin = {
      arch = "x64";
      hash = "sha256-rYfKXT1vysWG30IlCwqCfUj9kJugQ+6Ramm9UByjmRk=";
    };
  };

  inherit (platforms.${stdenvNoCC.hostPlatform.system}) arch hash;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "debugserver";
  version = "1.11.6";

  src = fetchurl {
    url = "https://github.com/vadimcn/codelldb/releases/download/v${finalAttrs.version}/codelldb-darwin-${arch}.vsix";
    inherit hash;
  };

  nativeBuildInputs = [ unzip ];

  buildCommand = ''
    unzip "$src"

    mkdir -p "$out/bin"
    cp extension/lldb/bin/debugserver "$out/bin"
  '';

  dontFixup = true;

  meta = {
    description = "debugserver binary for use with LLDB";
    homepage = "https://github.com/vadimcn/codelldb";
    license = lib.licenses.asl20;
    mainProgram = "debugserver";
    maintainers = [ lib.maintainers.reckenrode ];
    platforms = lib.platforms.darwin; # Other platforms are supported, but this is really only needed on Darwin.
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})

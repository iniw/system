{
  homeModule =
    let
      rust-prettifier =
        {
          lib,
          fetchgit,
          stdenvNoCC,
        }:
        stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "rust-prettifier-for-lldb";
          version = "0.5.1";

          src = fetchgit {
            url = "https://github.com/cmrschwarz/rust-prettifier-for-lldb.git";
            rev = "c97ed7a6305725655fe3b636509cc639dce31890";
            hash = "sha256-6EIR901c6PVOQApKVbpLf1DPHMwef3LUxFJji2PiduI=";
          };

          buildCommand = ''
            mkdir -p "$out/share"
            cp "$src/rust_prettifier_for_lldb.py" "$out/share"
          '';

          meta = {
            description = "Rust Prettifier Script for the LLDB Debugger";
            homepage = "https://github.com/cmrschwarz/rust-prettifier-for-lldb";
            license = lib.licenses.gpl3;
          };
        });
    in
    { pkgs, ... }:
    {
      home.file.".lldbinit".text = ''
        # Show more lines when printing source code
        settings set stop-line-count-after 15

        # Load project-specific .lldbinit files
        settings set target.load-cwd-lldbinit true

        # Disable LLDB 21's statusline
        settings set show-statusline false

        # Alias to save and load the breakpoints into a known (and gitignored) file
        command alias bs breakpoint write -f .breakpoints
        command alias bl breakpoint read -f .breakpoints

        # Improve printing of Rust-specific types
        command script import "${pkgs.callPackage rust-prettifier { }}/share/rust_prettifier_for_lldb.py"
      '';

      home.packages = [ pkgs.lldb_21 ];

      programs.git.ignores = [
        # Project-specific lldbinit
        ".lldbinit"
        # List of breakpoints saved/loaded with the bs/bl aliases
        ".breakpoints"
      ];
    };

  # Nix's LLDB doesn't find `debugserver` on darwin, so we download codelldb's version and tell LLDB to use it through `LLDB_DEBUGSERVER_PATH`.
  # This idea/code is taken from https://github.com/NixOS/nixpkgs/pull/374846 and should be removed if that ever lands (unlikely).
  # For context: https://github.com/NixOS/nixpkgs/issues/252838
  darwinHomeModule =
    let
      debugserver =
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
              hash = "sha256-TbbaTov2xX1cNuWrOl9q5hZkEgaMFO0WZheoX54O1/0=";
            };
            x86_64-darwin = {
              arch = "x64";
              hash = "sha256-ZvHuVyPbenXwWc2IGvVsE85fMM5JxMM7f5hqrKerzjI=";
            };
          };

          inherit (platforms.${stdenvNoCC.hostPlatform.system}) arch hash;
        in
        stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "debugserver";
          version = "1.11.5";

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
        });
    in
    { pkgs, ... }:
    {
      home.sessionVariables.LLDB_DEBUGSERVER_PATH = pkgs.callPackage debugserver { } |> pkgs.lib.getExe;
    };
}

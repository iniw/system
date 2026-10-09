{
  homeManagerModule = { pkgs, lib, ... }: {
    home =
      let
        inherit (pkgs) kache;
      in
      {
        packages = [ kache ];
        sessionPath = [ "${kache.shims}/bin" ];
        sessionVariables = lib.genAttrs [
          "RUSTC_WRAPPER"
          # The CMake launchers make CMake builds in Cargo build scripts (such as rdkafka) use kache.
          # The `cmake` crate gives CMake the full compiler path, so the shims do not apply there.
          "CMAKE_C_COMPILER_LAUNCHER"
          "CMAKE_CXX_COMPILER_LAUNCHER"
        ] (_: lib.getExe kache);
      };
  };
}

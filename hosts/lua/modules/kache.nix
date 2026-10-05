{
  systemModule =
    {
      inputs,
      config,
      lib,
      ...
    }:
    {
      imports = [ inputs.kache.nixosModules.kache ];

      # The module also sets `RUSTC_WRAPPER`.
      services.kache = {
        enable = true;
        daemon.enable = true;
      };

      environment.variables =
        let
          inherit (config.services.kache) package;
        in
        {
          PATH = [ "${package}/shims" ];
          # The CMake launchers make CMake builds in Cargo build scripts (such as rdkafka) use kache.
          # The `cmake` crate gives CMake the full compiler path, so the shims do not apply there.
          CMAKE_C_COMPILER_LAUNCHER = lib.getExe package;
          CMAKE_CXX_COMPILER_LAUNCHER = lib.getExe package;
        };
    };
}

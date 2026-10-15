{
  homeManagerModule =
    { pkgs, lib, ... }:
    let
      inherit (pkgs) kache;
    in
    {
      home = {
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

      systemd.user.services.kache = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        Unit.Description = "kache build cache daemon";
        Service = {
          ExecStart = "${lib.getExe kache} daemon run";
          Restart = "on-failure";
          RestartSec = "5s";
          Environment = [ "KACHE_LOG=kache=info" ];
        };
        Install.WantedBy = [ "default.target" ];
      };

      launchd.agents.kache = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        enable = true;
        config = {
          ProgramArguments = [
            (lib.getExe kache)
            "daemon"
            "run"
          ];
          RunAtLoad = true;
          KeepAlive.SuccessfulExit = false;
          ThrottleInterval = 5;
          EnvironmentVariables.KACHE_LOG = "kache=info";
        };
      };
    };
}

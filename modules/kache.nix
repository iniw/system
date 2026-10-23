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
        sessionVariables.RUSTC_WRAPPER = lib.getExe kache;
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
          Label = "ninja.kunobi.kache";
          RunAtLoad = true;
          KeepAlive.SuccessfulExit = false;
          ThrottleInterval = 5;
          EnvironmentVariables.KACHE_LOG = "kache=info";
        };
      };

      # A devshell puts its compiler before the shims in PATH, so add the shims again after `use flake` and `use nix`.
      # direnv loads this after nix-direnv (in `lib/`), so these wrap the nix-direnv functions.
      programs.direnv.stdlib = # sh
        ''
          eval "_kache_orig_$(declare -f use_flake)"
          use_flake() { _kache_orig_use_flake "$@" && PATH_add ${kache.shims}/bin; }
          eval "_kache_orig_$(declare -f use_nix)"
          use_nix() { _kache_orig_use_nix "$@" && PATH_add ${kache.shims}/bin; }
        '';
    };
}

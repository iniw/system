{
  homeModule = {
    programs.direnv = {
      enable = true;

      nix-direnv.enable = true;

      config.global = {
        hide_env_diff = true;
        strict_env = true;
      };

      # Store direnv caches in a unified location
      # From: https://github.com/direnv/direnv/wiki/Customizing-cache-location#human-readable-directories
      stdlib =
        # sh
        ''
          : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
          declare -A direnv_layout_dirs
          direnv_layout_dir() {
            local hash path
            echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(sha1sum - <<< "$PWD" | head -c40)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
            )}"
          }
        '';
    };

    programs.git.ignores = [ ".envrc" ];
  };
}

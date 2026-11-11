{
  homeManagerModule =
    { config, ... }:
    {
      # Bazel reads `~/.bazelrc` for every workspace, after the workspace's own `.bazelrc`.
      home.file.".bazelrc".text = ''
        # Keeps the outputs of every action by its key, so that Bazel puts back earlier results
        # rather than running the actions again, for example the tests' results after a run with
        # another `--test_filter`, or the builds after a `bazel clean` or a switch between
        # branches. The built-in action cache only knows the outputs that are on disk.
        common --disk_cache=${config.xdg.cacheHome}/bazel/disk

        # Bazel deletes the least recently used entries when the disk cache grows past this size,
        # while its server is idle.
        common --experimental_disk_cache_gc_max_size=100G
      '';

      # See https://github.com/nushell/nushell/issues/13381
      programs.nushell.extraConfig = # nu
        ''
          @complete external
          def --wrapped bazel [...rest: string] {
            ^bazel ...$rest
          }
        '';
    };
}

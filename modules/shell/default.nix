{
  homeManagerModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.nushell = {
        enable = true;

        configFile.source = ./config.nu;
      };

      programs.zsh.enable = pkgs.stdenv.hostPlatform.isDarwin;
      programs.bash.enable = pkgs.stdenv.hostPlatform.isLinux;

      # Ghostty starts without `XDG_CONFIG_HOME` on macOS, where nushell would then look for its config in
      # `~/Library/Application Support/nushell`, so pass the config directory explicitly.
      programs.ghostty.settings = {
        command = lib.escapeShellArgs [
          (lib.getExe config.programs.nushell.package)
          "--config-home"
          config.programs.nushell.configDir
          "--experimental-options"
          "native-clip"
        ];

        # Nushell reads `XDG_DATA_DIRS` once at launch to find the completions that packages install, before `env.nu`
        # loads the session variables. On macOS Ghostty starts without the nix profiles in it, and setting
        # `XDG_DATA_DIRS` here would remove the directory that Ghostty adds for its shell integration, so pass the
        # profile's directory instead.
        env = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin [
          "NU_VENDOR_AUTOLOAD_DIR=${config.home.profileDirectory}/share/nushell/vendor/autoload"
        ];
      };

      home.file.".hushlogin".text = "";
    };

  systemModule = {
    environment.pathsToLink = [ "/share/nushell" ];
  };
}

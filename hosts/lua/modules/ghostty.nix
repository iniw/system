{
  homeManagerModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.ghostty.settings = {
        font-size = 12;
        maximize = true;
        window-decoration = "none";
      };

      programs.plasma.configFile.kdeglobals.General = {
        # Plasma uses this value in two different ways:
        #
        # - `preferred://terminal` looks it up as the name of a desktop file.
        # - Other places (e.g. apps with `Terminal=true`) run it as a command.
        #
        # Ghostty's desktop file is not called `ghostty.desktop`, so the value `ghostty` only works as a command. To make
        # both work, we use the name of the desktop file here, and put a command with the same name in PATH.
        #
        # FIXME: Set this back to `ghostty` and remove the command once we are on Plasma 6.8, where
        # `preferred://terminal` uses `TerminalService` instead.
        # See: https://invent.kde.org/plasma/plasma-workspace/-/commit/a4a79fa1b4265a4a59562d3786cede405f7eae9c
        TerminalApplication = "com.mitchellh.ghostty.desktop";
        TerminalService = "com.mitchellh.ghostty.desktop";
      };

      # See the comment on `TerminalApplication` above.
      home.packages = [
        (pkgs.writeShellScriptBin "com.mitchellh.ghostty.desktop" ''
          exec ${lib.getExe config.programs.ghostty.package} "$@"
        '')
      ];

      xdg.autostart.entries = [
        "${config.programs.ghostty.package}/share/applications/com.mitchellh.ghostty.desktop"
      ];
    };
}

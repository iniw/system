{
  homeManagerModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.firefox = {
        enable = true;

        # FIXME: Remove once https://github.com/NixOS/nixpkgs/pull/567009 is merged
        package = pkgs.firefox.overrideAttrs (old: {
          makeWrapperArgs = old.makeWrapperArgs ++ [
            "--prefix"
            "LD_LIBRARY_PATH"
            ":"
            (lib.makeLibraryPath [ pkgs.libdbusmenu-gtk3 ])
          ];
        });

        policies.Preferences = {
          "widget.gtk.global-menu.enabled" = true;
          "widget.gtk.global-menu.wayland.enabled" = true;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
        };
      };

      xdg = {
        mimeApps.defaultApplications =
          [
            "application/xhtml+xml"
            "text/html"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ]
          |> lib.map (type: lib.nameValuePair type "firefox.desktop")
          |> lib.listToAttrs;

        autostart.entries = [
          "${config.programs.firefox.finalPackage}/share/applications/firefox.desktop"
        ];
      };
    };
}

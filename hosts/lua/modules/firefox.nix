{
  homeManagerModule = { config, lib, ... }: {
    programs.firefox = {
      enable = true;

      policies.Preferences = {
        "widget.gtk.global-menu.enabled" = true;
        "widget.gtk.global-menu.wayland.enabled" = true;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
      };
    };

    xdg = {
      mimeApps.defaultApplications = lib.genAttrs [
        "application/xhtml+xml"
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ] (_: "firefox.desktop");

      autostart.entries = [
        "${config.programs.firefox.finalPackage}/share/applications/firefox.desktop"
      ];
    };
  };
}

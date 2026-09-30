{
  homeManagerModule = { pkgs, ... }: {
    # Helix uses this to copy to and paste from the system clipboard on Wayland.
    home.packages = [ pkgs.wl-clipboard ];

    xdg.mimeApps.defaultApplications."text/*" = "Helix.desktop";
  };
}

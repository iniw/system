{ ... }:
{
  imports = [ ./shared.nix ];

  home = {
    sessionPath = [
      # I manually install mysql version 8.0.23 because it is the last version to support my old MacOS,
      # meaning it has be manually added to $PATH.
      "/usr/local/mysql/bin/"
    ];
  };

  xdg = {
    configFile = {
      "wezterm" = {
        source = ./wezterm;
        recursive = true;
      };
    };
  };
}

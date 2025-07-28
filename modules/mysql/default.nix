{
  darwinSystemModule = {
    homebrew.brews = [
      rec {
        name = "mysql";
        restart_service = "changed";
        conflicts_with = [ name ];
      }
    ];
  };

  nixosSystemModule = {
    services.mysql.enable = true;
  };
}

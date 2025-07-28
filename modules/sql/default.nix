{
  darwinSystemModule = {
    homebrew.brews = [
      rec {
        name = "mysql";
        restart_service = "changed";
        conflicts_with = [ name ];
      }
      rec {
        name = "postgresql@17";
        link = true;
        restart_service = "changed";
        conflicts_with = [ name ];
      }
    ];
  };

  nixosSystemModule = {
    services.mysql.enable = true;
    services.postgresql.enable = true;
  };
}

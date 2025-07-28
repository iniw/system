{
  darwinSystemModule = {
    homebrew.brews = [
      rec {
        name = "postgresql@17";
        restart_service = "changed";
        conflicts_with = [ name ];
      }
    ];
  };

  nixosSystemModule = {
    services.postgresql.enable = true;
  };
}

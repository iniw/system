{
  darwinModule = {
    homebrew.brews = [
      rec {
        name = "postgresql@17";
        restart_service = "changed";
        conflicts_with = [ name ];
      }
    ];
  };

  nixosModule = {
    services.postgresql.enable = true;
  };
}

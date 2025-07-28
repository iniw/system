{
  darwinModule = {
    homebrew.brews = [
      rec {
        name = "mysql";
        restart_service = "changed";
        conflicts_with = [ name ];
      }
    ];
  };

  nixosModule = {
    services.mysql.enable = true;
  };
}

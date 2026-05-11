{
  systemModule =
    { inputs, user, ... }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        extraSpecialArgs = {
          inherit inputs user;
        };

        backupFileExtension = "hm-backup";
      };
    };

  homeManagerModule = {
    xdg.enable = true;
    home.preferXdgDirectories = true;
  };
}

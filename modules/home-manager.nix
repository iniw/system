{
  systemModule =
    { inputs, ... }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        extraSpecialArgs = {
          inherit inputs;
        };

        backupFileExtension = "hm-backup";
      };
    };

  homeManagerModule = {
    xdg.enable = true;
    home.preferXdgDirectories = true;
  };
}

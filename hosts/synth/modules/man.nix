{
  systemModule =
    { pkgs, ... }:
    {
      documentation = {
        dev.enable = true;
        doc.enable = true;
        info.enable = true;
        man = {
          enable = true;
          cache.enable = true;
        };
      };

      environment.systemPackages = with pkgs; [
        man-pages
        man-pages-posix
      ];
    };
}

{
  systemModule = { pkgs, ... }: {
    documentation = {
      dev.enable = true;
      man.cache.enable = true;
    };

    environment.systemPackages = with pkgs; [
      man-pages
      man-pages-posix
    ];
  };
}

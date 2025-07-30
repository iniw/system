{
  homeModule =
    { pkgs, pkgs-unstable, ... }:
    {
      programs.helix = {
        enable = true;
        package = pkgs-unstable.helix;

        defaultEditor = true;

        # System-wide LSP support for languages used everywhere.
        extraPackages = [
          # Nix
          pkgs-unstable.nil
          pkgs-unstable.nixfmt
          # Markdown
          pkgs.marksman
          # Toml
          pkgs.taplo
        ];
      };

      xdg.configFile.helix = {
        source = ./config;
        recursive = true;
      };

      programs.git.ignores = [ ".helix" ];
    };
}

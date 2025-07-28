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
          pkgs.nil
          pkgs-unstable.nixfmt
          # Markdown
          pkgs.marksman
          # Toml
          pkgs.taplo
        ];
      };

      programs.git.ignores = [
        ".helix"
      ];

      xdg.configFile."helix" = {
        source = ./config;
        recursive = true;
      };
    };
}

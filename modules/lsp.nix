{
  homeManagerModule =
    { pkgs, ... }:
    {
      # System-wide LSP support for languages used everywhere.
      home.packages = with pkgs; [
        # Nix
        nixd
        nixfmt

        # Markdown
        marksman

        # Toml
        tombi

        # Yaml
        yaml-language-server
        yamlfmt # FIXME: Remove once https://github.com/helix-editor/helix/issues/15576 is fixed
        helm-ls
      ];

      xdg.configFile."yamlfmt/yamlfmt.yaml".text = # yaml
        ''
          formatter:
            retain_line_breaks_single: true
        '';
    };
}

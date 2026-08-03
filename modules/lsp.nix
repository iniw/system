{
  homeManagerModule = { pkgs, ... }: {
    # System-wide LSP support for languages used everywhere.
    home.packages = with pkgs; [
      # Nix
      nixd
      nixfmt

      # Markdown
      rumdl

      # Toml
      tombi

      # Yaml
      yaml-language-server
      yamlfmt # FIXME: Remove once https://github.com/helix-editor/helix/issues/15576 is fixed
      helm-ls
    ];

    xdg.configFile = {
      # https://rumdl.dev/global-settings/
      "rumdl/rumdl.toml".text = # toml
        ''
          [global]
          line-length = 120
          cache = false

          [per-file-ignores]
          # Disable annoying lints for ephemeral files
          "/{var/folders,tmp}/**" = [
            "MD013", # Line length
            "MD041", # First line heading
          ]
        '';

      # https://github.com/google/yamlfmt/blob/main/docs/config-file.md
      "yamlfmt/yamlfmt.yaml".text = # yaml
        ''
          formatter:
            retain_line_breaks_single: true
        '';
    };
  };
}

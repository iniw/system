{
  homeManagerModule = { pkgs, inputs, ... }: {
    home.packages =
      with pkgs;
      let
        inherit (inputs.nprt.packages.${stdenv.hostPlatform.system}) nprt;
      in
      [
        nprt
        okapi-ed
        ripgrep
      ];

    programs = {
      carapace = {
        enable = true;

        extraPackages = with pkgs; [
          fish
          inshellisense
        ];

        settings = {
          env = false;
          lenient = true;
          bridges = "fish,inshellisense";
        };
      };

      fzf =
        let
          fd = pkgs.lib.getExe pkgs.fd;
        in
        {
          enable = true;

          changeDirWidget.command = "${fd} --type directory";
          fileWidget.command = fd;
        };

      less = {
        enable = true;

        options = {
          RAW-CONTROL-CHARS = true;
          chop-long-lines = true;
          ignore-case = true;
          incsearch = true;
          no-init = true;
          quit-if-one-screen = true;
          quit-on-intr = true;
          status-column = true;
          use-color = true;
        };
      };

      nix-your-shell.enable = true;

      zoxide.enable = true;
    };
  };

  darwinHomeManagerModule = {
    # See: https://github.com/NixOS/nixpkgs/issues/456879
    home.shellAliases.man = "env -u DEVELOPER_DIR -u SDKROOT man";
  };

  nixosHomeManagerModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}

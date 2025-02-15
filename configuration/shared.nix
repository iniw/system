{
  user,
  overlays,
  pkgs,
  pkgs-unstable,
  neovim-nightly,
  ...
}:
{
  # User

  home-manager = {
    extraSpecialArgs = {
      inherit user pkgs-unstable neovim-nightly;
    };

    useGlobalPkgs = true;

    backupFileExtension = "hm-backup";
  };

  # Shell

  programs = {
    zsh = {
      enable = true;
    };
  };

  environment = {
    shells = [ pkgs.zsh ];
  };

  users.users.${user} = {
    shell = pkgs.zsh;
  };

  # SSH

  services = {
    openssh = {
      enable = true;
    };
  };

  # Nix

  nix = {
    settings = {
      trusted-users = [
        user
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs = {
    inherit overlays;

    config = {
      allowUnfree = true;
    };
  };
}

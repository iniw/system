{
  user,
  overlays,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  # User

  home-manager = {
    extraSpecialArgs = {
      inherit user pkgs-unstable;
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

      extra-substituters = ["https://helix.cachix.org"];
      extra-trusted-public-keys = ["helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="];
    };
  };

  nixpkgs = {
    inherit overlays;

    config = {
      allowUnfree = true;
    };
  };
}

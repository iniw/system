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
    };
  };

  nixpkgs = {
    inherit overlays;

    config = {
      allowUnfree = true;
    };
  };
}

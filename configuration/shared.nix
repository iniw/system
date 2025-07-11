{
  user,
  overlays,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
{
  # User

  home-manager = {
    extraSpecialArgs = {
      inherit user pkgs-unstable inputs;
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

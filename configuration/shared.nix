{
  user,
  overlay,
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
    useUserPackages = true;

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
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs = {
    overlays = [ overlay ];

    config = {
      allowUnfree = true;
    };
  };
}

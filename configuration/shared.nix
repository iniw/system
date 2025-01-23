{
  user,
  overlay,
  pkgs,
  ...
}:
{
  nix = {
    extraOptions = ''
      keep-outputs = false
      keep-derivations = false
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = {
    overlays = [ overlay ];
    config.allowUnfree = true;
  };

  # Set zsh as the default/login shell to avoid problems when using a non-posix compliant (nu) shell.
  # See: https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
  #      https://wiki.archlinux.org/title/Fish#System_integration
  #      https://wiki.gentoo.org/wiki/Fish#Caveats
  programs.zsh.enable = true;

  environment.shells = [ pkgs.zsh ];

  users.users.${user} = {
    name = user;
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = {
      inherit user;
    };

    useGlobalPkgs = true;
    useUserPackages = true;

    backupFileExtension = "hm-backup";
  };
}

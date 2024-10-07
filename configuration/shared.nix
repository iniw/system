{
  pkgs,
  user,
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

  programs.zsh.enable = true;

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
  };
}

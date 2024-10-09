{
  pkgs,
  user,
  self,
  overlay,
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

  nixpkgs.overlays = [ overlay ];

  programs.zsh.enable = true;

  users.users.${user} = {
    name = user;
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = {
      inherit user;
      inherit self;
    };

    useGlobalPkgs = true;
    useUserPackages = true;
  };
}

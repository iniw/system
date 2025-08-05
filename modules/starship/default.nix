{
  homeModule = {
    programs.starship.enable = true;
    xdg.configFile."starship.toml".source = ./config/starship.toml;
  };
}

{
  homeManagerModule = { config, ... }: {
    programs.discord.enable = true;

    xdg.autostart.entries = [
      "${config.programs.discord.package}/share/applications/discord.desktop"
    ];
  };
}

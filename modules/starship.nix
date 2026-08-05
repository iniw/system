{
  homeManagerModule = {
    programs.starship = {
      enable = true;

      settings = {
        add_newline = false;

        format = ''
          [╭](white)$hostname$time$directory$nix_shell$cmd_duration$status$fill[─](white)
          [╰](white)[❯](blue) '';

        fill = {
          symbol = "─";
          style = "white";
        };

        hostname = {
          format = "[─](white) [$hostname]($style) ";
          style = "light-white";
        };

        time = {
          format = "[─](white) [$time]($style) ";
          time_format = "%H:%M";
          style = "blue";
          disabled = false;
        };

        directory = {
          format = "[─](white) [$path]($style)[$read_only]($read_only_style) ";
          style = "cyan";
          truncate_to_repo = false;
          truncation_length = 0;
          read_only = "*";
        };

        nix_shell = {
          format = "[─](white) [$name]($style) ";
          style = "bright-black";
        };

        cmd_duration = {
          format = "[─](white) [$duration]($style) ";
          style = "yellow";
        };

        status = {
          format = "[─](white) [$status]($style) ";
          disabled = false;
          map_symbol = true;
        };
      };
    };
  };
}

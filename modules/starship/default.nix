{
  homeModule =
    { lib, ... }:
    {
      programs.starship = {
        enable = true;
        settings = {
          format =
            let
              modules = lib.concatStrings [
                "$time"
                "$directory"
                "$nix_shell"
                "$cmd_duration"
                "$status"
              ];
            in
            ''
              ┌${modules}
              └❯'';

          time = {
            format = ''\[[$time]($style)\]'';
            time_format = "%H:%M";
            style = "cyan";
            disabled = false;
          };

          directory = {
            format = ''─\[[$path]($style)[$read_only]($read_only_style)\]'';
            style = "blue";
            truncate_to_repo = false;
            read_only = "*";
          };

          cmd_duration = {
            format = ''─\[[$duration]($style)\]'';
            style = "yellow";
          };

          status = {
            format = ''─\[[$status]($style)\]'';
            disabled = false;
            map_symbol = true;
          };

          nix_shell = {
            format = ''─\[[$name]($style)\]'';
            style = "bright-black";
          };
        };
      };
    };
}

{
  homeManagerModule = { pkgs, ... }: {
    programs.ghostty = {
      enable = true;
      package = with pkgs; if stdenv.hostPlatform.isDarwin then ghostty-bin else ghostty;

      settings = {
        auto-update = "off";

        # style
        theme = "dark:lua,light:sol";

        # cursor
        cursor-color = "cell-foreground";
        cursor-text = "cell-background";
        mouse-hide-while-typing = true;
        shell-integration-features = "no-cursor";

        # window
        window-padding-x = 0;
        window-padding-y = 0;
        window-padding-balance = true;

        # misc
        confirm-close-surface = false;

        # keybinds
        macos-option-as-alt = "left";
        keybind = [
          "clear"

          # global
          "ctrl+g>u=undo"
          "ctrl+g>p=toggle_command_palette"
          "global:super+:=toggle_quick_terminal"

          # tab
          "ctrl+g>n=new_tab"
          "ctrl+g>d=close_surface"
          "ctrl+g>shift+d=close_tab"
          "ctrl+g>shift+h=previous_tab"
          "ctrl+g>shift+l=next_tab"
          "ctrl+tab=next_tab"
          "ctrl+shift+tab=previous_tab"

          # split
          "ctrl+g>s=new_split:down"
          "ctrl+g>v=new_split:right"
          "ctrl+g>h=goto_split:left"
          "ctrl+g>j=goto_split:down"
          "ctrl+g>k=goto_split:up"
          "ctrl+g>l=goto_split:right"
          "ctrl+g>z=toggle_split_zoom"

          # scroll
          "ctrl+g>up=scroll_page_lines:-1"
          "ctrl+g>down=scroll_page_lines:1"
          "ctrl+g>shift+up=scroll_page_up"
          "ctrl+g>shift+down=scroll_page_down"
          "ctrl+g>alt+up=scroll_to_top"
          "ctrl+g>alt+down=scroll_to_bottom"

          # window
          "all:super+shift+0=reset_font_size"
          "all:super+shift+equal=increase_font_size:1"
          "all:super+shift+minus=decrease_font_size:1"

          # find
          "ctrl+g>f=start_search"
          "performable:escape=end_search"

          # clipboard
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"
        ];
      };

      # https://www.ditig.com/256-colors-cheat-sheet
      themes =
        let
          dark = "#0d0d0d";
          light = "#f5f5f5";
        in
        {
          sol = {
            background = light;
            foreground = dark;
            palette =
              let
                red = "#a60000";
                green = "#61a600";
                yellow = "#a66f00";
                blue = "#0061a6";
                purple = "#8a53a6";
                cyan = "#00a66f";
                gray = "#bfbfbf";
                dark-gray = "#949494";
              in
              [
                "0=${light}"
                "8=${dark-gray}"

                "1=${red}"
                "9=${red}"

                "2=${green}"
                "10=${green}"

                "3=${yellow}"
                "11=${yellow}"

                "4=${blue}"
                "12=${blue}"

                "5=${purple}"
                "13=${purple}"

                "6=${cyan}"
                "14=${cyan}"

                "7=${gray}"
                "15=${dark}"
              ];
          };

          lua = {
            background = dark;
            foreground = light;
            palette =
              let
                red = "#e67373";
                green = "#b6e673";
                yellow = "#e6bf73";
                blue = "#73b6e6";
                purple = "#bf73e6";
                cyan = "#73e6bf";
                dark-gray = "#4d4d4d";
                light-gray = "#949494";
              in
              [
                "0=${dark}"
                "8=${light-gray}"

                "1=${red}"
                "9=${red}"

                "2=${green}"
                "10=${green}"

                "3=${yellow}"
                "11=${yellow}"

                "4=${blue}"
                "12=${blue}"

                "5=${purple}"
                "13=${purple}"

                "6=${cyan}"
                "14=${cyan}"

                "7=${dark-gray}"
                "15=${light}"
              ];
          };
        };
    };
  };
}

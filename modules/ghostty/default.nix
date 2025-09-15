{
  darwinSystemModule = {
    # FIXME: Use ghostty-bin package once 1.2.0 lands on unstable
    homebrew.casks = [ "ghostty" ];
  };

  homeModule =
    { pkgs-unstable, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = if pkgs-unstable.stdenv.isDarwin then null else pkgs-unstable.ghostty;

        settings = {
          auto-update = "off";

          # style
          font-family = "Berkeley Mono";
          font-size = 15;
          theme = "dark:lua,light:sol";

          # cursor
          cursor-invert-fg-bg = true;
          shell-integration-features = "no-cursor";
          mouse-hide-while-typing = true;

          # window
          window-padding-x = 0;
          window-padding-y = 0;
          macos-titlebar-style = "tabs";

          # keybinds
          macos-option-as-alt = true;

          keybind = [
            "clear"

            # keybinds.tab
            "super+n=new_tab"
            "super+d=close_surface"
            "super+shift+d=close_tab"
            "super+shift+h=previous_tab"
            "super+shift+l=next_tab"

            # keybinds.split
            "super+s=new_split:down"
            "super+v=new_split:right"
            "super+h=goto_split:left"
            "super+j=goto_split:down"
            "super+k=goto_split:up"
            "super+l=goto_split:right"
            "super+z=toggle_split_zoom"

            # keybinds.scroll
            "super+up=scroll_page_lines:-1"
            "super+down=scroll_page_lines:1"
            "super+shift+up=scroll_page_up"
            "super+shift+down=scroll_page_down"
            "super+alt+up=scroll_to_top"
            "super+alt+down=scroll_to_bottom"

            # keybinds.clipboard
            "ctrl+shift+c=copy_to_clipboard"
            "ctrl+shift+v=paste_from_clipboard"

            # keybinds.misc
            "super+q=quit"
            "super+f=toggle_fullscreen"
            "super+u=undo"
            "super+shift+0=reset_font_size"
            "super+shift+plus=increase_font_size:1"
            "super+shift+minus=decrease_font_size:1"
            "super+shift+p=toggle_command_palette"
            "global:super+shift+;=toggle_quick_terminal"
          ];
        };

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
                  "1=${red}"
                  "2=${green}"
                  "3=${yellow}"
                  "4=${blue}"
                  "5=${purple}"
                  "6=${cyan}"
                  "7=${gray}"
                  "8=${dark-gray}"
                  "9=${red}"
                  "10=${dark}"
                  "11=${yellow}"
                  "12=${blue}"
                  "13=${purple}"
                  "14=${cyan}"
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
                  "1=${red}"
                  "2=${green}"
                  "3=${yellow}"
                  "4=${blue}"
                  "5=${purple}"
                  "6=${cyan}"
                  "7=${dark-gray}"
                  "8=${light-gray}"
                  "9=${red}"
                  "10=${light}"
                  "11=${yellow}"
                  "12=${blue}"
                  "13=${purple}"
                  "14=${cyan}"
                  "15=${light}"
                ];
            };
          };
      };
    };

  nixosHomeModule = {
    # Remove some default keybinds that conflict with the config.
    dconf.settings = {
      "org/gnome/shell/keybindings" = {
        # super+s
        toggle-quick-settings = [ ];
        # super+v
        toggle-message-tray = [ ];
        # super+n
        focus-active-notification = [ ];
        # super+alt+up
        shift-overview-up = [ ];
        # super+alt+down
        shift-overview-down = [ ];
      };

      "org/gnome/desktop/wm/keybindings" = {
        # super+h
        minimize = [ ];
        # super+up
        maximize = [ ];
        # super+down
        unmaximize = [ ];
        # super+shift+up
        move-to-monitor-up = [ ];
        # super+shift+down
        move-to-monitor-down = [ ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        # super+l
        screensaver = [ ];
      };
    };
  };
}

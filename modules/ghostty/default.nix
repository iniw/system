{
  darwinSystemModule = {
    homebrew.casks = [ "ghostty@tip" ];
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

        themes = {
          sol = {
            background = "#f5f5f5";
            foreground = "#0d0d0d";

            palette = [
              "0=#f5f5f5"
              "1=#a60000"
              "2=#61a600"
              "3=#a66f00"
              "4=#0061a6"
              "5=#8a53a6"
              "6=#00a66f"
              "7=#bfbfbf"
              "8=#949494"
              "9=#a60000"
              "10=#0d0d0d"
              "11=#a66f00"
              "12=#0061a6"
              "13=#8a53a6"
              "14=#00a66f"
              "15=#0d0d0d"
            ];
          };

          lua = {
            background = "#0d0d0d";
            foreground = "#f5f5f5";

            palette = [
              "0=#0d0d0d"
              "1=#e67373"
              "2=#b6e673"
              "3=#e6bf73"
              "4=#73b6e6"
              "5=#bf73e6"
              "6=#73e6bf"
              "7=#4d4d4d"
              "8=#949494"
              "9=#e67373"
              "10=#f5f5f5"
              "11=#e6bf73"
              "12=#73b6e6"
              "13=#bf73e6"
              "14=#73e6bf"
              "15=#f5f5f5"
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

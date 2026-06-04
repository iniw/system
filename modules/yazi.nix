{
  homeManagerModule = {
    programs = {
      yazi = {
        enable = true;

        settings.mgr.show_hidden = true;

        keymap.mgr.prepend_keymap = [
          {
            run = ''shell -- ya emit cd "$(jj workspace root)"'';
            on = [
              "g"
              "r"
            ];
            desc = "Go to repository root";
          }
        ];
      };

      helix.settings.keys = {
        normal.ret =
          let
            open-yazi = expansion: [
              ":sh rm -f /tmp/yazi-chooser-file"
              '':insert-output yazi "%{${expansion}}" --chooser-file=/tmp/yazi-chooser-file''
              ":sh printf '\033[?1049h\033[?2004h' > /dev/tty"
              ":open %sh{cat /tmp/yazi-chooser-file}"
              ":redraw"
              ":set mouse false"
              ":set mouse true"
            ];
          in
          {
            e = open-yazi "buffer_name";
            S-e = open-yazi "workspace_directory";
          };
      };
    };
  };
}
